import Foundation

struct Item: Codable {
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

extension Item: Identifiable {}

extension Item {
    var formattedWeight: String {
        return weight.formattedWeight(authorUnit)
    }

    var fullImageURL: URL? {
        if let imageUrl = URL(string: imageUrl) {
            return imageUrl
        }
        if image.isEmpty { return nil }
        let imgurURL = "https://i.imgur.com/\(image).jpg"
        return URL(string: imgurURL)
    }
}
