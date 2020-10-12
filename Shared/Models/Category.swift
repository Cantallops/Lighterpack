import Foundation

struct Category {
    var id: Int
    var name: String

    var categoryItems: [CategoryItem]
    var subtotalWeight: Float
    var subtotalWornWeight: Float
    var subtotalConsumableWeight: Float
    var subtotalPrice: Float
    var subtotalWornPrice: Float
    var subtotalConsumablePrice: Float
    var subtotalQty: Int
    var subtotalWornQty: Int
    var subtotalConsumableQty: Int

    var activeHover: Bool?
    var displayColor: String?
    var color: CategoryColor?
}

extension Category: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.categoryItems = try container.decode([CategoryItem].self, forKey: .categoryItems)

        self.subtotalWeight = try container.decodeIfPresent(Float.self, forKey: .subtotalWeight) ?? 0
        self.subtotalWornWeight = try container.decodeIfPresent(Float.self, forKey: .subtotalWornWeight) ?? 0
        self.subtotalConsumableWeight = try container.decodeIfPresent(Float.self, forKey: .subtotalConsumableWeight) ?? 0
        self.subtotalPrice = try container.decodeIfPresent(Float.self, forKey: .subtotalPrice) ?? 0
        self.subtotalWornPrice = try container.decodeIfPresent(Float.self, forKey: .subtotalWornPrice) ?? 0
        self.subtotalConsumablePrice = try container.decodeIfPresent(Float.self, forKey: .subtotalConsumablePrice) ?? 0
        self.subtotalQty = try container.decodeIfPresent(Int.self, forKey: .subtotalQty) ?? 0
        self.subtotalWornQty = try container.decodeIfPresent(Int.self, forKey: .subtotalWornQty) ?? 0
        self.subtotalConsumableQty = try container.decodeIfPresent(Int.self, forKey: .subtotalConsumableQty) ?? 0

        self.activeHover = try container.decodeIfPresent(Bool.self, forKey: .activeHover)
        self.displayColor = try container.decodeIfPresent(String.self, forKey: .displayColor)
        self.color = try container.decodeIfPresent(CategoryColor.self, forKey: .color)
    }
}

extension Category: Identifiable {}
extension Category: Equatable {}

public struct CategoryColor: Codable, Equatable {
    let r: Int
    let g: Int
    let b: Int
}
extension Category {
    static let placeholder: Category = Category(id: -1, name: "", categoryItems: [], subtotalWeight: 0, subtotalWornWeight: 0, subtotalConsumableWeight: 0, subtotalPrice: 0, subtotalWornPrice: 0, subtotalConsumablePrice: 0, subtotalQty: 0, subtotalWornQty: 0, subtotalConsumableQty: 0, activeHover: nil, displayColor: nil, color: nil)

    var isPlaceholder: Bool { self.id == Category.placeholder.id }
}
