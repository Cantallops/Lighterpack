import Foundation

public struct SaveEndpoint: Endpoint {
    public typealias Response = LighterPackSaveResponse
    public var httpMethod: HttpMethod { .POST }
    public var path: String { "saveLibrary/" }
    public var authenticated: Bool { true }
}

public struct LighterPackSaveResponse: Codable {
    let message: String
    let syncToken: Int
}
