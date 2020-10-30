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
        logger.info("Called \(#function) with category id \(category.id)")
        guard let index = localRepo.library.categories.firstIndex(where: { $0.id == category.id }) else {
            logger.fault("Category id \(category.id) does not exists")
            return
        }
        guard category != localRepo.library.categories[index] else { return }
        localRepo.library.categories[index] = category
        localRepo.recompute()
        sync()
    }

    func remove(categoryWithId id: Int) {
        logger.info("Called \(#function) with category id \(id)")
        guard let index = localRepo.library.categories.firstIndex(where: { $0.id == id }) else {
            return
                logger.fault("Category id \(id) does not exists")
        }
        localRepo.library.categories.remove(at: index)
        localRepo.recompute()
        sync()
    }

    func move(itemsInCategoryWithId id: Int, from source: IndexSet, to destination: Int) {
        logger.info("Called \(#function) with category id \(id), source \(source), destination \(destination)")
        guard let index = localRepo.library.categories.firstIndex(where: { $0.id == id }) else {
            logger.fault("Category id \(id) does not exists")
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
        logger.info("Called \(#function) with category id \(id)")
        let categories = localRepo.library.categories
        guard let index = categories.firstIndex(where: { $0.id == id }) else {
            logger.fault("Category id \(id) does not exists")
            return nil
        }
        return categories[index]
    }
}

internal extension Repository {
    func create(category unidentifiedCategory: Entities.Category) -> Entities.Category {
        logger.info("Called \(#function)")
        let sequence = localRepo.library.sequence
        localRepo.library.sequence += 1
        var identifiedCategory = unidentifiedCategory
        identifiedCategory.id = sequence
        localRepo.library.categories.append(identifiedCategory)
        localRepo.recompute()
        return identifiedCategory
    }
}
