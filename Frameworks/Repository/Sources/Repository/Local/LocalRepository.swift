import Foundation
import Entities
import Combine

public protocol LocalRepository {
    var username: String { get set }
    var library: Library { get set }
    var originalLibrary: Library? { get set }
    var syncToken: Int { get set }

    var cookie: String? { get set }

    func recompute()
}

public extension LocalRepository {
    var hasChanges: Bool {
        library != originalLibrary
    }

    mutating func logout() {
        library = .placeholder
        originalLibrary = nil
        syncToken = 0
        cookie = nil
    }
}


public class AppLocalRepository: LocalRepository, ObservableObject {
    @Published public var username: String = ""
    @Published public var library: Library = .placeholder
    @Published public var originalLibrary: Library?
    @Published public var syncToken: Int = 0
    @Published public var cookie: String?

    public init() {}

    public func recompute() {
        library = recompute(library: library)
    }
}

private extension AppLocalRepository {
    private func recompute(
        library: Library
    ) -> Library {
        let computedCategories = recompute(library.categories, using: library.items)
        let computedlists = recompute(library.lists, using: computedCategories)
        var mutableLibrary = library
        mutableLibrary.categories = computedCategories
        mutableLibrary.lists = computedlists
        return mutableLibrary
    }

    func recompute(_ categoryItems: [CategoryItem], using items: [Item]) -> [CategoryItem] {
        categoryItems.compactMap { oldCategoryItem -> CategoryItem? in
            var newCategoryItem = oldCategoryItem
            guard let item = items.first(where: { $0.id == oldCategoryItem.id}) else {
                return nil
            }

            newCategoryItem.price = item.price * Float(oldCategoryItem.qty)
            newCategoryItem.weight = item.weight * Float(oldCategoryItem.qty)

            return newCategoryItem
        }
    }

    func recompute(_ categories: [Entities.Category], using items: [Item]) -> [Entities.Category] {
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

    func recompute(_ lists: [Entities.List], using categories: [Entities.Category]) -> [Entities.List] {
        lists.map { preprocessedList in
            var newList = preprocessedList
            let categories = categories.filter { preprocessedList.categoryIds.contains($0.id) }

            newList.categoryIds = categories.map { $0.id }
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

