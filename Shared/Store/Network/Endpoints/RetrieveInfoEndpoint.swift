import Foundation

public struct RetrieveInfoEndpoint: Endpoint {
    public typealias Response = LighterPackResponse
    public var httpMethod: HttpMethod { .POST }
    public var path: String { "signin" }
    public var authenticated: Bool { true }
}

