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
    @UserDefault("sessionCookie", defaultValue: "") var cookie: String

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
            headers["Cookie"] = "lp=73744df1460ce75fa61153e7c484647a69dd84a2c8c178dca55a882d297c00141f98517287d0f5a6742f3f3fa1fa8060"
        }
        headers["Content-Type"] = "application/json"
        request.allHTTPHeaderFields = headers
        return run(request)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }


    func run<T: Decodable>(_ request: URLRequest) -> AnyPublisher<T, Error> {
        return urlSession
            .dataTaskPublisher(for: request)
            .tryMap { result -> T in
                updateCookies(result.response)
                let value = try JSONDecoder().decode(T.self, from: result.data)
                return value
            }
            .eraseToAnyPublisher()
    }

    private func updateCookies(_ response: URLResponse) {
        guard let setCookie = (response as? HTTPURLResponse)?.value(forHTTPHeaderField: "Set-Cookie") else { return }
        let components = setCookie.split(separator: ";")
        cookie = String(components.first ?? "")
    }
}
