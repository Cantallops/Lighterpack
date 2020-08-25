import Foundation

extension DBItem {
    var formattedWeight: String {
        let weightUnit = WeigthUnit(rawValue: authorUnit) ?? .oz
        return weight.formattedWeight(weightUnit)
    }

    var fullImageURL: URL? {
        if let imageUrl = URL(string: imageURL) {
            return imageUrl
        }
        if image.isEmpty { return nil }
        let imgurURL = "https://i.imgur.com/\(image).jpg"
        return URL(string: imgurURL)
    }
}
