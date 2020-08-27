import Foundation

public struct SignInEndpoint: Endpoint {
    public typealias Response = LighterPackResponse
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

    public func processNetworkError(_ error: NetworkError) -> NetworkError {
        guard error.codeStatus == .unauthorized || error.codeStatus == .notFound else {
            return error
        }
        var networkError: NetworkError.ErrorType = .messages([
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
        return NetworkError(
            codeStatus: error.codeStatus,
            error: networkError
        )
    }
}
