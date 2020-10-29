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

    public var headers: [String : String] {
        [
            "Cookie": cookie
        ]
    }

    public var authenticated: Bool { true }

    let username: String
    let currentPassword: String
    let newPassword: String
    let cookie: String
}

public struct ChangePasswordResponse: Codable {
    let message: String
}

