import Foundation
import Combine

public class LighterPackAccess {
    var urlSession: URLSession = .shared
    var baseUrl = URL(string: "https://lighterpack.com/")!

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
        headers["Content-Type"] = "application/json"
        request.allHTTPHeaderFields = headers
        return run(request)
            .tryMap(endpoint.processResponse)
            .mapError(endpoint.processError)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }


    func run(_ request: URLRequest) -> AnyPublisher<(HTTPURLResponse, Data), Error> {
        return urlSession
            .dataTaskPublisher(for: request)
            .tryMap { [weak self] result in
                guard let response = result.response as? HTTPURLResponse,
                      let status = response.status else {
                    throw RepositoryError(codeStatus: HTTPStatusCode.internalServerError.rawValue, error: .unknown) // TODO better error
                }
                switch status.responseType {
                case .success:
                    return (response, result.data)
                default:
                    try self?.removeCookieIfNeeded(request, response: response, data: result.data)
                    if let formErrorEntry = try? JSONDecoder().decode(FormErrorEntry.self, from: result.data) {
                        throw RepositoryError(codeStatus: status.rawValue, error: .form([formErrorEntry]))
                    }
                    if let formError = try? JSONDecoder().decode(FormErrors.self, from: result.data) {
                        throw RepositoryError(codeStatus: status.rawValue, error: .form(formError.errors))
                    }
                    if let errorMessage = try? JSONDecoder().decode(ErrorMessage.self, from: result.data) {
                        throw RepositoryError(codeStatus: status.rawValue, error: .messages([errorMessage]))
                    }
                    if let errorMessages = try? JSONDecoder().decode(ErrorMessages.self, from: result.data) {
                        throw RepositoryError(codeStatus: status.rawValue, error: .messages(errorMessages.errors))
                    }
                    throw RepositoryError(codeStatus: status.rawValue, error: .unknown)
                }
            }
            .eraseToAnyPublisher()
    }

    private func removeCookieIfNeeded(_ request: URLRequest, response: HTTPURLResponse, data: Data) throws {
        // https://github.com/galenmaly/lighterpack/blob/75a056faaa67286fd4c9aa779b4e8a467a4f0302/server/auth.js#L53
        guard response.status == .notFound || response.status == .unauthorized else { return }
        guard let cookie = request.allHTTPHeaderFields?["Cookie"], !cookie.isEmpty else { return }
        guard let message = (try? JSONDecoder().decode(ErrorMessage.self, from: data))?.message else { return }
        guard message == "Please log in again." || message == "Please log in." else { return }
        throw RepositoryError(codeStatus: 401, error: .unauthenticated(message))
    }
}
