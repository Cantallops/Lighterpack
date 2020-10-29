import Foundation
import Entities

public struct SignInEndpoint: Endpoint {
    public typealias Response = String
    public var httpMethod: HttpMethod { .POST }
    public var path: String { "signin/" }
    public var params: [String : Any]? {
        [
            "username": username,
            "password": password
        ]
    }

    let username: String
    let password: String

    public init(username: String, password: String) {
        self.username = username
        self.password = password
    }

    public func processResponse(response: HTTPURLResponse, data: Data) throws -> Response {
        guard let setCookie = response.value(forHTTPHeaderField: "Set-Cookie") else {
            throw RepositoryError(codeStatus: HTTPStatusCode.unauthorized.rawValue, error: .message("Unauthorized"))
        }
        let components = setCookie.split(separator: ";")
        guard let rawCookie = components.first else {
            throw RepositoryError(codeStatus: HTTPStatusCode.unauthorized.rawValue, error: .message("Unauthorized"))
        }
        return String(rawCookie)
    }

    public func processNetworkError(_ error: RepositoryError) -> RepositoryError {
        guard error.codeStatus == HTTPStatusCode.unauthorized.rawValue || error.codeStatus == HTTPStatusCode.notFound.rawValue else {
            return error
        }
        var networkError: RepositoryError.ErrorType = .messages([
            .init(message: "Invalid username and/or password.")
        ])
        if username.isEmpty && password.isEmpty {
            networkError = .messages([
                .init(message: "Please enter username and password.")
            ])
        } else if username.isEmpty {
            networkError = .form([
                .init(field: .username, message: "Please enter a username.")
            ])
        } else if password.isEmpty {
            networkError = .form([
                .init(field: .password, message: "Please enter a password.")
            ])
        }
        return RepositoryError(
            codeStatus: error.codeStatus,
            error: networkError
        )
    }
}
