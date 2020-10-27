import Foundation
import Entities
import Entities

public struct RegisterEndpoint: Endpoint {
    public typealias Response = LighterPackResponse
    public var httpMethod: HttpMethod { .POST }
    public var path: String { "register/" }
    public var params: [String : Any]? {
        [
            "email": email,
            "username": username,
            "password": password
        ]
    }

    let email: String
    let username: String
    let password: String

    public init(email: String, username: String, password: String) {
        self.email = email
        self.username = username
        self.password = password
    }

    public func processNetworkError(_ error: NetworkError) -> NetworkError {
        // FIXME
        return error
    }
}
