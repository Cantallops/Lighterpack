import Foundation

struct GearList: Codable  {
    let id: Int
    let name: String
    let categoryIds: [Int]
    let description: String
    let externalId: String
    let totalWeight: Float
    let totalWornWeight: Float
    let totalConsumableWeight: Float
    let totalBaseWeight: Float
    let totalPackWeight: Float
    let totalPrice: Float
    let totalConsumablePrice: Float
    let totalQty: Int
}
