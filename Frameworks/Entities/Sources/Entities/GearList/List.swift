import Foundation

public struct List {
    public var id: Int
    public var name: String
    public var categoryIds: [Int]
    public var description: String
    public var externalId: String
    public var totalWeight: Float
    public var totalWornWeight: Float
    public var totalConsumableWeight: Float
    public var totalBaseWeight: Float
    public var totalPackWeight: Float
    public var totalPrice: Float
    public var totalConsumablePrice: Float
    public var totalWornPrice: Float
    public var totalQty: Int

    public init(
        id: Int,
        name: String,
        categoryIds: [Int],
        description: String,
        externalId: String,
        totalWeight: Float,
        totalWornWeight: Float,
        totalConsumableWeight: Float,
        totalBaseWeight: Float,
        totalPackWeight: Float,
        totalPrice: Float,
        totalConsumablePrice: Float,
        totalWornPrice: Float,
        totalQty: Int
    ) {
        self.id = id
        self.name = name
        self.categoryIds = categoryIds
        self.description = description
        self.externalId = externalId
        self.totalWeight = totalWeight
        self.totalWornWeight = totalWornWeight
        self.totalConsumableWeight = totalConsumableWeight
        self.totalBaseWeight = totalBaseWeight
        self.totalPackWeight = totalPackWeight
        self.totalPrice = totalPrice
        self.totalConsumablePrice = totalConsumablePrice
        self.totalWornPrice = totalWornPrice
        self.totalQty = totalQty
    }
}

extension List: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.categoryIds = try container.decode([Int].self, forKey: .categoryIds)
        self.description = try container.decode(String.self, forKey: .description)
        self.externalId = try container.decode(String.self, forKey: .externalId)

        self.totalWeight = try container.decodeIfPresent(Float.self, forKey: .totalWeight) ?? 0
        self.totalWornWeight = try container.decodeIfPresent(Float.self, forKey: .totalWornWeight) ?? 0
        self.totalConsumableWeight = try container.decodeIfPresent(Float.self, forKey: .totalConsumableWeight) ?? 0
        self.totalBaseWeight = try container.decodeIfPresent(Float.self, forKey: .totalBaseWeight) ?? 0
        self.totalPackWeight = try container.decodeIfPresent(Float.self, forKey: .totalPackWeight) ?? 0
        self.totalPrice = try container.decodeIfPresent(Float.self, forKey: .totalPrice) ?? 0
        self.totalConsumablePrice = try container.decodeIfPresent(Float.self, forKey: .totalConsumablePrice) ?? 0
        self.totalWornPrice = try container.decodeIfPresent(Float.self, forKey: .totalWornPrice) ?? 0
        self.totalQty = try container.decodeIfPresent(Int.self, forKey: .totalQty) ?? 0
    }
}


extension List: Identifiable {}
extension List: Equatable {}

public extension List {
    var shareUrl: URL? {
        guard !externalId.isEmpty else { return nil }
        guard var url = URL(string: "https://lighterpack.com/r/") else { return nil }
        url.appendPathComponent(externalId)
        return url
    }
}
