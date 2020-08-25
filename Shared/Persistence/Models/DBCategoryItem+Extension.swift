import Foundation

extension DBCategoryItem {
    var weight: Float { item.weight * Float(quantity) }
    var price: Float { item.price * Float(quantity) }

    var formattedWeight: String {
        let weightUnit = WeigthUnit(rawValue: item.authorUnit) ?? .oz
        return weight.formattedWeight(weightUnit)
    }
}


extension DBCategoryItem {
    var model: CategoryItem {
        CategoryItem(
            qty: Int(quantity),
            worn: worn,
            consumable: consumable,
            star: Int(star),
            itemId: Int(item.id)
        )
    }
}
