import Foundation

public struct Category {
    public var id: Int
    public var name: String

    public var categoryItems: [CategoryItem]

    public var subtotalWeight: Float
    public var subtotalWornWeight: Float
    public var subtotalConsumableWeight: Float
    public var subtotalPrice: Float
    public var subtotalWornPrice: Float
    public var subtotalConsumablePrice: Float
    public var subtotalQty: Int
    public var subtotalWornQty: Int
    public var subtotalConsumableQty: Int

    public var activeHover: Bool?
    public var displayColor: String?
    public var color: CategoryColor? {
        didSet {
            guard let c = color else { return }
            displayColor = "rgb(\(c.r),\(c.g),\(c.b)"
        }
    }

    public init(
        id: Int,
        name: String,
        categoryItems: [CategoryItem],
        subtotalWeight: Float,
        subtotalWornWeight: Float,
        subtotalConsumableWeight: Float,
        subtotalPrice: Float,
        subtotalWornPrice: Float,
        subtotalConsumablePrice: Float,
        subtotalQty: Int,
        subtotalWornQty: Int,
        subtotalConsumableQty: Int,
        activeHover: Bool?,
        displayColor: String?,
        color: CategoryColor?
    ) {
        self.id = id
        self.name = name
        self.categoryItems = categoryItems
        self.subtotalWeight = subtotalWeight
        self.subtotalWornWeight = subtotalWornWeight
        self.subtotalConsumableWeight = subtotalConsumableWeight
        self.subtotalPrice = subtotalPrice
        self.subtotalWornPrice = subtotalWornPrice
        self.subtotalConsumablePrice = subtotalConsumablePrice
        self.subtotalQty = subtotalQty
        self.subtotalWornQty = subtotalWornQty
        self.subtotalConsumableQty = subtotalConsumableQty
        self.activeHover = activeHover
        self.displayColor = displayColor
        self.color = color
    }

    public init() {
        self.init(id: -10, name: "", categoryItems: [], subtotalWeight: 0, subtotalWornWeight: 0, subtotalConsumableWeight: 0, subtotalPrice: 0, subtotalWornPrice: 0, subtotalConsumablePrice: 0, subtotalQty: 0, subtotalWornQty: 0, subtotalConsumableQty: 0, activeHover: nil, displayColor: nil, color: nil)
    }
}

extension Category: Identifiable {}
extension Category: Equatable {}

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
