import Foundation
import Entities
import Combine

public extension Repository {
    func getAllItems() -> [Item] {
        localRepo.library.items
    }

    /*
    func getAllItems() -> Future<[Item], Error> {
        Future<[Item], Error> { [unowned self] promise in
            DispatchQueue.global(qos: .userInteractive).async {
                promise(.success(self.localRepo.library.items))
            }
        }
    }*/

    func get(itemWithId id: Int) -> Future<Item, Error> {
        Future<Item, Error> { [unowned self] promise in
            DispatchQueue.global(qos: .userInteractive).async {
                guard let item = self.get(itemWithId: id) else {
                    promise(.failure(RepositoryError.itemNotFound(id)))
                    return
                }
                promise(.success(item))
            }
        }
    }

    func update(item: Item) {
        guard let index = localRepo.library.items.firstIndex(where: { $0.id == item.id }) else {
            return
        }
        guard item != localRepo.library.items[index] else { return }
        localRepo.library.items[index] = item
        localRepo.recompute()
        sync()
    }

    func remove(itemWithId id: Int) {
        guard let index = localRepo.library.items.firstIndex(where: { $0.id == id }) else {
            return
        }
        localRepo.library.items.remove(at: index)
        localRepo.recompute()
        sync()
    }

    func create(item unidentifiedItem: Item) {
        let sequence = localRepo.library.sequence
        var identifiedItem = unidentifiedItem
        identifiedItem.id = sequence
        localRepo.library.sequence = sequence + 1
        localRepo.library.items.append(identifiedItem)
        localRepo.recompute()
        sync()
    }

    func move(from source: IndexSet, to destination: Int) {
        let set = NSMutableOrderedSet(array: localRepo.library.items)
        set.moveObjects(at: source, to: destination)
        localRepo.library.items = set.array as! [Item]
        sync()
    }

}

public extension Repository {
    func get(itemWithId id: Int) -> Item? {
        let items = localRepo.library.items
        guard let index = items.firstIndex(where: { $0.id == id }) else {
            return nil
        }
        return items[index]
    }
}
