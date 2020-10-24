import Foundation

struct CategoryItem {
    var qty: Int
    var worn: Bool
    var consumable: Bool
    var star: StarColor
    let itemId: Int

    var price: Float
    var weight: Float

}

extension CategoryItem: Codable {
    init(from decoder: Decoder) throws {
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
    var id: Int { itemId }
}
extension CategoryItem: Equatable {}

extension CategoryItem {
    static let placeholder: CategoryItem = .init(qty: 0, worn: false, consumable: false, star: .none, itemId: -1, price: 0, weight: 0)

    var isPlaceholder: Bool { self.id == CategoryItem.placeholder.id }
}
