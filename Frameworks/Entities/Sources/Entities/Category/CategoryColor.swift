import Foundation

public struct CategoryColor: Equatable {
    public let r: Int
    public let g: Int
    public let b: Int

    public init(
        r: Int,
        g: Int,
        b: Int
    ) {
        self.r = r
        self.g = g
        self.b = b
    }
}

extension CategoryColor: Codable {}
