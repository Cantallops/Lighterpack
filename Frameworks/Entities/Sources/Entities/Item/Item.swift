import Foundation

public struct Item: Codable {
    public var id: Int
    public var name: String
    public var description: String
    public var weight: Float
    public var authorUnit: WeightUnit
    public var price: Float
    public var image: String
    public var imageUrl: String
    public var url: String

    public init(
        id: Int,
        name: String,
        description: String,
        weight: Float,
        authorUnit: WeightUnit,
        price: Float,
        image: String,
        imageUrl: String,
        url: String
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.weight = weight
        self.authorUnit = authorUnit
        self.price = price
        self.image = image
        self.imageUrl = imageUrl
        self.url = url
    }
}

extension Item: Identifiable {}
extension Item: Equatable {}

public extension Item {

    var fullImageURL: URL? {
        if let imageUrl = URL(string: imageUrl) {
            return imageUrl
        }
        if image.isEmpty { return nil }
        let imgurURL = "https://i.imgur.com/\(image).jpg"
        return URL(string: imgurURL)
    }
}

public extension Item {
    static let placeholder: Item = .init(
        id: -1,
        name: "Item's name",
        description: "Description, Description, Description, Description, Description, Description,",
        weight: 10000000,
        authorUnit: .kg,
        price: 50,
        image: "",
        imageUrl: "",
        url: ""
    )

    var isPlaceholder: Bool { self.id == Item.placeholder.id }
}
