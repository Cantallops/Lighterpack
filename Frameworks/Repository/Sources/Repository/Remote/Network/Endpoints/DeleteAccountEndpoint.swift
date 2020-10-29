import Foundation

public struct DeleteAccountEndpoint: Endpoint {
    public typealias Response = DeleteAccountResponse
    public var httpMethod: HttpMethod { .POST }
    public var path: String { "delete-account/" }
    public var params: [String : Any]? {
        [
            "username": username,
            "password": password
        ]
    }
    public var headers: [String : String] {
        [
            "Cookie": cookie
        ]
    }

    let username: String
    let password: String
    let cookie: String
}

public struct DeleteAccountResponse: Codable {
    let message: String
}
