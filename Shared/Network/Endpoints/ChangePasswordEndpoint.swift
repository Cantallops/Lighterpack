import Foundation

public struct ChangePasswordEndpoint: Endpoint {
    public typealias Response = ChangePasswordResponse
    public var httpMethod: HttpMethod { .POST }
    public var path: String { "account/" }
    public var params: [String : Any]? {
        [
            "username": username,
            "newPassword": newPassword,
            "currentPassword": currentPassword
        ]
    }

    public var authenticated: Bool { true }

    let username: String
    let currentPassword: String
    let newPassword: String

    public init(
        username: String,
        currentPassword: String,
        newPassword: String
    ) {
        self.username = username
        self.currentPassword = currentPassword
        self.newPassword = newPassword
    }
}

public struct ChangePasswordResponse: Codable {
    let message: String
}

