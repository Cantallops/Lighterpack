import Foundation

struct GearList: Codable {
    let id: Int
    var name: String
    var categoryIds: [Int]
    var description: String
    var externalId: String
    var totalWeight: Float
    var totalWornWeight: Float
    var totalConsumableWeight: Float
    var totalBaseWeight: Float
    var totalPackWeight: Float
    var totalPrice: Float
    var totalConsumablePrice: Float
    var totalWornPrice: Float
    var totalQty: Int

    init(
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

    init(from decoder: Decoder) throws {
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

extension GearList: Identifiable {}

extension GearList {
    var shareUrl: URL? {
        guard !externalId.isEmpty else { return nil }
        guard var url = URL(string: "https://lighterpack.com/r/") else { return nil }
        url.appendPathComponent(externalId)
        return url
    }
}


extension GearList {
    static var placeholder: GearList = .init(id: 0, name: "List", categoryIds: [], description: "Description list", externalId: "", totalWeight: 200, totalWornWeight: 200, totalConsumableWeight: 300, totalBaseWeight: 300, totalPackWeight: 200, totalPrice: 200, totalConsumablePrice: 200, totalWornPrice: 200, totalQty: 100)
}
