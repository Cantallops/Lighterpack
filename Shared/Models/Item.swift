import Foundation

struct Item: Codable  {
    let id: Int
    let name: String
    let description: String
    let weight: Float
    let authorUnit: WeigthUnit
    let price: Float
    let image: String
    let imageUrl: String
    let url: String
}
