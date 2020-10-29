import Foundation
import Entities

public struct RetrieveInfoEndpoint: Endpoint {
    public typealias Response = LighterPackResponse
    public var httpMethod: HttpMethod { .POST }
    public var path: String { "signin" }

    public var headers: [String : String] {
        [
            "Cookie": cookie
        ]
    }

    let cookie: String
}

