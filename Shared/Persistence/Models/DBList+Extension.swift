import Foundation

extension DBList {

    var categoriesArray: [DBCategory] {
        (categories.array as? [DBCategory]) ?? []
    }

    var quantity: Int16 {
        categoriesArray.reduce(Int16(0)) { $0 + $1.quantity }
    }

    var price: Float {
        categoriesArray.reduce(0.0) { $0 + $1.price }
    }

    var weight: Float {
        categoriesArray.reduce(0.0) { $0 + $1.weight }
    }

    var shareUrl: URL? {
        guard !externalId.isEmpty else { return nil }
        guard var url = URL(string: "https://lighterpack.com/r/") else { return nil }
        url.appendPathComponent(externalId)
        return url
    }
}

