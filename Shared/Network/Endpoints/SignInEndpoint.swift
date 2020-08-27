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
        var message = "Invalid username and/or password."
        if username.isEmpty && password.isEmpty {
            message = "Please enter username and password."
        } else if username.isEmpty {
            message = "Please enter a username."
        } else if password.isEmpty {
            message = "Please enter a password."
        }
        return NetworkError(
            codeStatus: error.codeStatus,
            errorMessage: .init(message: message)
        )
    }
}
