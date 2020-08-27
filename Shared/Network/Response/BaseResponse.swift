import Foundation

public struct LighterPackResponse: Codable {
    let username: String
    let library: Library
    let syncToken: Int

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.username = try container.decode(String.self, forKey: .username)
        self.syncToken = try container.decode(Int.self, forKey: .syncToken)

        let rawLibrary: String = try container.decode(String.self, forKey: .library)
        let data = rawLibrary.data(using: .utf8)!
        self.library = try JSONDecoder().decode(Library.self, from: data)
    }
}
