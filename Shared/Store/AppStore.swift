import Foundation
import Combine
import Entities
import SwiftUI
import Repository

extension Repository {
    func binding(forList list: Entities.List) -> Binding<Entities.List> {
        return .init(get: {
            self.get(listWithId: list.id) ?? list
        }, set: update)
    }

    func binding(forItem item: Item) -> Binding<Item> {
        return .init(get: {
            self.get(itemWithId: item.id) ?? item
        }, set: update)
    }


    func binding(forCategoryItem item: CategoryItem, in category: Entities.Category) -> Binding<CategoryItem> {
        return .init(get: {
            self.get(categoryWithId: category.id)?.categoryItems.first(where: { $0.itemId == item.itemId }) ?? item
        }, set: { newCategoyItem in
            var modifiedCategory = category
            modifiedCategory.categoryItems.append(newCategoyItem)
            self.update(category: modifiedCategory)
        })
    }

    func binding(forCategory category: Entities.Category) -> Binding<Entities.Category> {
        return .init(get: {
            self.get(categoryWithId: category.id) ?? category
        }, set: update)
    }
}
