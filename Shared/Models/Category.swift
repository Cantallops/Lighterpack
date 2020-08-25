import Foundation

struct Category: Codable {
    let id: Int
    let name: String
    let categoryItems: [CategoryItem]
    let subtotalWeight: Float
    let subtotalWornWeight: Float
    let subtotalConsumableWeight: Float
    let subtotalPrice: Float
    let subtotalConsumablePrice: Float
    let subtotalQty: Int
    let activeHover: Bool?
    let displayColor: String?
    let color: CategoryColor?
}

struct CategoryItem: Codable  {
    let qty: Int
    let worn: Bool
    let consumable: Bool
    let star: Int
    let itemId: Int

    init(
        qty: Int,
        worn: Bool,
        consumable: Bool,
        star: Int,
        itemId: Int
    ) {
        self.qty = qty
        self.worn = worn
        self.consumable = consumable
        self.star = star
        self.itemId = itemId
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.qty = try container.decode(Int.self, forKey: .qty)
        self.star = try container.decode(Int.self, forKey: .star)
        self.itemId = try container.decode(Int.self, forKey: .itemId)

        // Worn and consumable could come as an int
        self.worn = try container.decodeIntBool(forKey: .worn)
        self.consumable = try container.decodeIntBool(forKey: .consumable)

    }
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



struct CategoryColor: Codable {
    let r: Int
    let g: Int
    let b: Int
}

enum StarColor: Int, CaseIterable, Codable {
    case none = 0
    case yellow
    case red
    case green
}
