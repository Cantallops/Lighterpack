import Foundation

public struct SaveEndpoint: Endpoint {
    public typealias Response = LighterPackSaveResponse
    public var httpMethod: HttpMethod { .POST }
    public var path: String { "saveLibrary/" }
    public var params: [String : Any]? {
        [
            "username": username,
            "syncToken": syncToken,
            "data": data
        ]
    }
    public var headers: [String : String] {
        [
            "Cookie": cookie
        ]
    }

    let username: String
    let data: String
    let syncToken: Int
    let cookie: String
}

public struct LighterPackSaveResponse: Codable {
    let message: String
    let syncToken: Int
}
