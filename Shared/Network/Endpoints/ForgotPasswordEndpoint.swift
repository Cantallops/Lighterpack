import Foundation

public struct ForgotPasswordEndpoint: Endpoint {
    public typealias Response = ForgotPasswordResponse
    public var httpMethod: HttpMethod { .POST }
    public var path: String { "forgotPassword/" }
    public var params: [String : Any]? {
        [
            "username": username
        ]
    }

    let username: String

    public init(username: String) {
        self.username = username
    }

    public func processNetworkError(_ error: NetworkError) -> NetworkError {
        guard error.codeStatus == .unauthorized || error.codeStatus == .notFound else {
            return error
        }
        var message = "Invalid username."
        if username.isEmpty {
            message = "Please enter a username."
        }
        return NetworkError(
            codeStatus: error.codeStatus,
            errorMessage: .init(message: message)
        )
    }
}


public struct ForgotPasswordResponse: Codable {
    var username: String
}
