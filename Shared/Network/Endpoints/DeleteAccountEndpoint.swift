import Foundation

public struct DeleteAccountEndpoint: Endpoint {
    public typealias Response = LighterPackResponse
    public var httpMethod: HttpMethod { .POST }
    public var path: String { "delete-account/" }
    public var params: [String : Any]? {
        [
            "username": username,
            "password": password
        ]
    }

    let username: String
    let password: String

    public var authenticated: Bool { true }

    public init(username: String, password: String) {
        self.username = username
        self.password = password
    }
}
