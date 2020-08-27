import Foundation

public struct ForgotUsernameEndpoint: Endpoint {
    public typealias Response = ForgotUsernameResponse
    public var httpMethod: HttpMethod { .POST }
    public var path: String { "forgotUsername/" }
    public var params: [String : Any]? {
        [
            "email": email
        ]
    }

    let email: String

    public init(email: String) {
        self.email = email
    }

    public func processNetworkError(_ error: NetworkError) -> NetworkError {
        guard error.codeStatus == .unauthorized || error.codeStatus == .notFound else {
            return error
        }
        var message = "Invalid email."
        if email.isEmpty {
            message = "Please enter an email."
        }
        return NetworkError(
            codeStatus: error.codeStatus,
            errorMessage: .init(message: message)
        )
    }
}

public struct ForgotUsernameResponse: Codable {
    var email: String
}
