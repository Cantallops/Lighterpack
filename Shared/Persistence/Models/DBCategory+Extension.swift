import Foundation

extension DBCategory {

    var itemsArray: [DBCategoryItem] {
        (items.array as? [DBCategoryItem]) ?? []
    }

    var quantity: Int16 {
        itemsArray.reduce(0) { $0 + $1.quantity }
    }

    var wornQuantity: Int16 {
        itemsArray.reduce(0) {
            $0 + ($1.worn ? $1.quantity : 0)
        }
    }

    var consumbleQuantity: Int16 {
        itemsArray.reduce(0) {
            $0 + ($1.consumable ? $1.quantity : 0)
        }
    }

    var baseQuantity: Int16 {
        quantity - consumbleQuantity
    }

    var price: Float {
        itemsArray.reduce(0.0) { $0 + $1.price }
    }

    var wornPrice: Float {
        itemsArray.reduce(0.0) {
            $0 + ($1.worn ? $1.price : 0)
        }
    }

    var consumblePrice: Float {
        itemsArray.reduce(0.0) {
            $0 + ($1.consumable ? $1.price : 0)
        }
    }

    var basePrice: Float {
        price - consumblePrice
    }

    var weight: Float {
        itemsArray.reduce(0.0) { $0 + $1.weight }
    }

    var wornWeight: Float {
        itemsArray.reduce(0.0) {
            $0 + ( $1.worn ? $1.weight : 0)
        }
    }

    var consumbleWeight: Float {
        itemsArray.reduce(0.0) {
            $0 + ($1.consumable ? $1.weight : 0)
        }
    }

    var baseWeight: Float {
        weight - consumbleWeight
    }

}
