import Foundation
import Combine
import Repository

public protocol CookieProvider {
    var cookie: String { get set }
}

public class LighterPackAccess {
    var urlSession: URLSession = .shared
    var baseUrl = URL(string: "https://lighterpack.com/")!
    var cookieProvider: CookieProvider?

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
            headers["Cookie"] = cookieProvider?.cookie
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
            .tryMap { [weak self] result -> T in
                guard let response = result.response as? HTTPURLResponse,
                      let status = response.status else {
                    throw NetworkError(codeStatus: .internalServerError, error: .unknown) // TODO
                }
                switch status.responseType {
                case .success:
                    self?.updateCookies(response)
                    let value = try JSONDecoder().decode(T.self, from: result.data)
                    return value
                default:
                    self?.removeCookieIfNeeded(request, response: response, data: result.data)
                    if let formErrorEntry = try? JSONDecoder().decode(FormErrorEntry.self, from: result.data) {
                        throw NetworkError(codeStatus: status, error: .form([formErrorEntry]))
                    }
                    if let formError = try? JSONDecoder().decode(FormErrors.self, from: result.data) {
                        throw NetworkError(codeStatus: status, error: .form(formError.errors))
                    }
                    if let errorMessage = try? JSONDecoder().decode(ErrorMessage.self, from: result.data) {
                        throw NetworkError(codeStatus: status, error: .messages([errorMessage]))
                    }
                    if let errorMessages = try? JSONDecoder().decode(ErrorMessages.self, from: result.data) {
                        throw NetworkError(codeStatus: status, error: .messages(errorMessages.errors))
                    }
                    throw NetworkError(codeStatus: status, error: .unknown)
                }
            }
            .eraseToAnyPublisher()
    }

    private func updateCookies(_ response: HTTPURLResponse) {
        guard let setCookie = response.value(forHTTPHeaderField: "Set-Cookie") else { return }
        let components = setCookie.split(separator: ";")
        cookieProvider?.cookie = String(components.first ?? "")
    }

    private func removeCookieIfNeeded(_ request: URLRequest, response: HTTPURLResponse, data: Data) {
        // https://github.com/galenmaly/lighterpack/blob/75a056faaa67286fd4c9aa779b4e8a467a4f0302/server/auth.js#L53
        guard response.status == .notFound || response.status == .unauthorized else { return }
        guard let cookie = request.allHTTPHeaderFields?["Cookie"], !cookie.isEmpty else { return }
        guard let message = (try? JSONDecoder().decode(ErrorMessage.self, from: data))?.message else { return }
        guard message == "Please log in again." || message == "Please log in." else { return }
        cookieProvider?.cookie = ""
    }
}
