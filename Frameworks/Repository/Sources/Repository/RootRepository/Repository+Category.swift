import Foundation
import Entities
import Combine

public extension Repository {
    func get(categoryWithId id: Int) -> Future<Entities.Category, Error> {
        Future<Entities.Category, Error> { [unowned self] promise in
            DispatchQueue.global(qos: .userInteractive).async {
                guard let category = self.get(categoryWithId: id) else {
                    promise(.failure(RepositoryError.categoryNotFound(id)))
                    return
                }
                promise(.success(category))
            }
        }
    }

    func update(category: Entities.Category) {
        guard let index = localRepo.library.categories.firstIndex(where: { $0.id == category.id }) else {
            return
        }
        guard category != localRepo.library.categories[index] else { return }
        localRepo.library.categories[index] = category
        localRepo.recompute()
        sync()
    }

    func remove(categoryWithId id: Int) {
        guard let index = localRepo.library.categories.firstIndex(where: { $0.id == id }) else {
            return
        }
        localRepo.library.categories.remove(at: index)
        localRepo.recompute()
        sync()
    }

    func move(itemsInCategoryWithId id: Int, from source: IndexSet, to destination: Int) {
        guard let index = localRepo.library.categories.firstIndex(where: { $0.id == id }) else {
            return
        }
        var category = localRepo.library.categories[index]
        let set = NSMutableOrderedSet(array: category.categoryItems)
        set.moveObjects(at: source, to: destination)
        category.categoryItems = set.array as! [CategoryItem]

        localRepo.library.categories[index] = category
        localRepo.recompute()
        sync()
    }
}

public extension Repository {
    func get(categoryWithId id: Int) -> Entities.Category? {
        let categories = localRepo.library.categories
        guard let index = categories.firstIndex(where: { $0.id == id }) else {
            return nil
        }
        return categories[index]
    }
}

internal extension Repository {
    func create(category unidentifiedCategory: Entities.Category) -> Entities.Category {
        let sequence = localRepo.library.sequence
        localRepo.library.sequence += 1
        var identifiedCategory = unidentifiedCategory
        identifiedCategory.id = sequence
        localRepo.library.categories.append(identifiedCategory)
        localRepo.recompute()
        return identifiedCategory
    }
}
