import Foundation

public struct LighterPackResponse {
    public let username: String
    public let library: Library
    public let syncToken: Int

    public init(
        username: String,
        library: Library,
        syncToken: Int
    ) {
        self.username = username
        self.library = library
        self.syncToken = syncToken
    }

}


extension LighterPackResponse: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.username = try container.decode(String.self, forKey: .username)
        self.syncToken = try container.decode(Int.self, forKey: .syncToken)

        let rawLibrary: String = try container.decode(String.self, forKey: .library)
        let data = rawLibrary.data(using: .utf8)!
        self.library = try JSONDecoder().decode(Library.self, from: data)
    }
}
