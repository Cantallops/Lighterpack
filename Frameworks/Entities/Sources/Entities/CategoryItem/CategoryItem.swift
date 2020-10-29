import Foundation

public struct CategoryItem {
    public var qty: Int
    public var worn: Bool
    public var consumable: Bool
    public var star: StarColor
    public let itemId: Int
    public var price: Float
    public var weight: Float

    public init(
        qty: Int,
        worn: Bool,
        consumable: Bool,
        star: StarColor,
        itemId: Int,
        price: Float,
        weight: Float
    ) {
        self.qty = qty
        self.worn = worn
        self.consumable = consumable
        self.star = star
        self.itemId = itemId
        self.price = price
        self.weight = weight
    }

}

public enum StarColor: Int, CaseIterable, Codable {
    case none = 0
    case yellow
    case red
    case green

    public var title: String {
        switch self {
        case .none: return "None"
        case .yellow: return "Yellow"
        case .red: return "Red"
        case .green: return "Green"
        }
    }
}

extension CategoryItem: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.qty = try container.decode(Int.self, forKey: .qty)
        self.star = try container.decode(StarColor.self, forKey: .star)
        self.itemId = try container.decode(Int.self, forKey: .itemId)

        // Worn and consumable could come as an int
        self.worn = try container.decodeIntBool(forKey: .worn)
        self.consumable = try container.decodeIntBool(forKey: .consumable)

        self.price = try container.decodeIfPresent(Float.self, forKey: .price) ?? 0
        self.weight = try container.decodeIfPresent(Float.self, forKey: .weight) ?? 0
    }
}


extension CategoryItem: Identifiable {
    public var id: Int { itemId }
}
extension CategoryItem: Equatable {}

public extension CategoryItem {
    static let placeholder: CategoryItem = .init(qty: 0, worn: false, consumable: false, star: .none, itemId: -1, price: 0, weight: 0)

    var isPlaceholder: Bool { self.id == CategoryItem.placeholder.id }
}

extension KeyedDecodingContainer {
    public func decodeIntBool(forKey key: KeyedDecodingContainer<K>.Key) throws -> Bool {
        do {
            return (try decode(Int.self, forKey: key)) != 0
        } catch DecodingError.typeMismatch {
            return try decode(Bool.self, forKey: key)
        }
    }
}
