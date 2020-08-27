//
//  Network.swift
//  LighterPack
//
//  Created by acantallops on 2020/08/19.
//

import Foundation
import Combine

public struct LighterPackAccess {
    var urlSession: URLSession = .shared
    var baseUrl = URL(string: "https://lighterpack.com/")!
    @UserDefault(.sessionCookie, defaultValue: "") var cookie: String

    public init() {}
}


public extension LighterPackAccess {
    func request<Request: Endpoint>(_ endpoint: Request) -> AnyPublisher<Request.Response, Error> {
        guard let components = URLComponents(url: baseUrl.appendingPathComponent(endpoint.path), resolvingAgainstBaseURL: true)
            else {
            fatalError("Couldn't create URLComponents")
        }
        var request = URLRequest(url: components.url!)
        request.httpMethod = endpoint.httpMethod.rawValue
        if let params = endpoint.params {
            request.httpBody = try? JSONSerialization.data(withJSONObject: params)
        }
        var headers = endpoint.headers
        if endpoint.authenticated {
            headers["Cookie"] = cookie
        }
        headers["Content-Type"] = "application/json"
        request.allHTTPHeaderFields = headers
        return run(request)
            .mapError(endpoint.processError)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }


    func run<T: Decodable>(_ request: URLRequest) -> AnyPublisher<T, Error> {
        return urlSession
            .dataTaskPublisher(for: request)
            .tryMap { result -> T in
                guard let response = result.response as? HTTPURLResponse,
                      let status = response.status else {
                    throw NetworkError(codeStatus: .internalServerError, errorMessage: nil) // TODO
                }
                switch status.responseType {
                case .success:
                    updateCookies(response)
                    let value = try JSONDecoder().decode(T.self, from: result.data)
                    return value
                default:
                    let errorMessage = try? JSONDecoder().decode(ErrorMessage.self, from: result.data)
                    throw NetworkError(codeStatus: status, errorMessage: errorMessage)
                }
            }
            .eraseToAnyPublisher()
    }

    private func updateCookies(_ response: HTTPURLResponse) {
        guard let setCookie = response.value(forHTTPHeaderField: "Set-Cookie") else { return }
        let components = setCookie.split(separator: ";")
        cookie = String(components.first ?? "")
    }
}
