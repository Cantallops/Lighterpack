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

    public func processNetworkError(_ error: RepositoryError) -> RepositoryError {
        guard error.codeStatus == HTTPStatusCode.unauthorized.rawValue || error.codeStatus == HTTPStatusCode.notFound.rawValue else {
            return error
        }
        
        var message = "Invalid username."
        if username.isEmpty {
            message = "Please enter a username."
        }
        return RepositoryError(
            codeStatus: error.codeStatus,
            error: .form([
                .init(field: .username, message: message)
            ])
        )
    }
}


public struct ForgotPasswordResponse: Codable {
    var username: String
}
