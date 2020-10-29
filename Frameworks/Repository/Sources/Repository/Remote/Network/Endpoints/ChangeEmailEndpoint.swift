import Foundation

public struct ChangeEmailEndpoint: Endpoint {
    public typealias Response = ChangeEmailResponse
    public var httpMethod: HttpMethod { .POST }
    public var path: String { "account/" }
    public var params: [String : Any]? {
        [
            "username": username,
            "newEmail": email,
            "currentPassword": currentPassword
        ]
    }
    public var headers: [String : String] {
        [
            "Cookie": cookie
        ]
    }

    let username: String
    let currentPassword: String
    let email: String
    let cookie: String
}

public struct ChangeEmailResponse: Codable {
    let message: String
}
