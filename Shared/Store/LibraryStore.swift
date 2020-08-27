import Foundation
import Combine

final class LibraryStore: ObservableObject {
    var networkAccess: LighterPackAccess = .init()
    var sessionStore: SessionStore = .init()

    var sequence: Int = 0
    @Published private(set) var items: [Item] = []
    @Published private(set) var lists: [GearList] = []
    @Published private(set) var categories: [Category] = []

    init() {
    }
}

extension LibraryStore {
    func categories(ofList list: GearList) -> [Category] {
        categories(ofList: list, using: categories)
    }

    func categories(ofList list: GearList, using categories: [Category] ) -> [Category] {
        categories.filter {
            list.categoryIds.contains($0.id)
        }
    }

    func category(withId id: Int) -> Category? {
        categories.first { $0.id == id }
    }
}

extension LibraryStore {
    func item(withId id: Int) -> Item? {
        item(withId: id, using: items)
    }


    func item(withId id: Int, using: [Item]) -> Item? {
        items.first { $0.id == id }
    }
}

extension LibraryStore {
    func update(with library: Library) {
        items = library.items
        categories = recompute(library.categories, using: items)
        lists = recompute(library.lists, using: categories)
    }
}

private extension LibraryStore {

    func recompute(_ categoryItems: [CategoryItem], using items: [Item]) -> [CategoryItem] {
        categoryItems.map { oldCategoryItem -> CategoryItem in
            var newCategoryItem = oldCategoryItem
            guard let item = item(withId: oldCategoryItem.itemId, using: items) else { return newCategoryItem }

            newCategoryItem.price = item.price * Float(oldCategoryItem.qty)
            newCategoryItem.weight = item.weight * Float(oldCategoryItem.qty)

            return newCategoryItem
        }
    }

    func recompute(_ categories: [Category], using items: [Item]) -> [Category] {
        categories.map { oldCategory in
            var newCategory = oldCategory
            let newCategoryItems = recompute(oldCategory.categoryItems, using: items)
            newCategory.categoryItems = newCategoryItems
            newCategory.subtotalWeight = newCategoryItems.reduce(0, {
                $0 + $1.weight
            })
            newCategory.subtotalWornWeight = newCategoryItems.reduce(0, {
                $0 + ($1.worn ? $1.weight : 0)
            })
            newCategory.subtotalConsumableWeight = newCategoryItems.reduce(0, {
                $0 + ($1.consumable ? $1.weight : 0)
            })
            newCategory.subtotalPrice = newCategoryItems.reduce(0, {
                $0 + $1.price
            })
            newCategory.subtotalWornPrice = newCategoryItems.reduce(0, {
                $0 + ($1.worn ? $1.price : 0)
            })
            newCategory.subtotalConsumablePrice = newCategoryItems.reduce(0, {
                $0 + ($1.consumable ? $1.price : 0)
            })
            newCategory.subtotalQty = newCategoryItems.reduce(0, {
                $0 + $1.qty
            })
            newCategory.subtotalWornQty = newCategoryItems.reduce(0, {
                $0 + ($1.worn ? $1.qty : 0)
            })
            newCategory.subtotalConsumableQty = newCategoryItems.reduce(0, {
                $0 + ($1.consumable ? $1.qty : 0)
            })
            return newCategory
        }
    }

    func recompute(_ lists: [GearList], using categories: [Category]) -> [GearList] {
        lists.map { preprocessedList in
            var newList = preprocessedList
            let categories = self.categories(ofList: preprocessedList, using: categories)


            newList.totalWeight = categories.reduce(0, { $0 + $1.subtotalWeight })
            newList.totalWornWeight = categories.reduce(0, { $0 + $1.subtotalWornWeight })
            newList.totalConsumableWeight = categories.reduce(0, { $0 + $1.subtotalConsumableWeight })
            newList.totalPrice = categories.reduce(0, { $0 + $1.subtotalPrice })
            newList.totalConsumablePrice = categories.reduce(0, { $0 + $1.subtotalConsumablePrice })
            newList.totalWornPrice = categories.reduce(0, { $0 + $1.subtotalWornPrice })
            newList.totalQty = categories.reduce(0, { $0 + $1.subtotalQty })
            newList.totalBaseWeight = newList.totalWeight - (newList.totalWornWeight + newList.totalConsumableWeight);
            newList.totalPackWeight = newList.totalWeight - newList.totalWornWeight;

            return newList
        }
    }
}
