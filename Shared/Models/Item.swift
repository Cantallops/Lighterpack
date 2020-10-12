import Foundation

struct Item: Codable {
    var id: Int
    var name: String
    var description: String
    var weight: Float
    var authorUnit: WeightUnit
    var price: Float
    var image: String
    var imageUrl: String
    var url: String
}

extension Item: Identifiable {}
extension Item: Equatable {}

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

extension Item {
    static let placeholder: Item = .init(id: -1, name: "", description: "", weight: 0, authorUnit: .g, price: 1, image: "", imageUrl: "", url: "")

    var isPlaceholder: Bool { self.id == Item.placeholder.id }
}
