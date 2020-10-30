import Foundation
import Entities
import Combine

public extension Repository {

    func getAllLists() -> [List] {
        localRepo.library.lists
    }

    /*func getAllLists() -> Future<[List], Error> {
        Future<[List], Error> { [unowned self] promise in
            DispatchQueue.global(qos: .userInteractive).async {
                promise(.success(self.localRepo.library.lists))
            }
        }
    }*/

    func get(listWithId id: Int) -> Future<List, Error> {
        Future<List, Error> { [unowned self] promise in
            DispatchQueue.global(qos: .userInteractive).async {
                guard let list = self.get(listWithId: id) else {
                    promise(.failure(RepositoryError.listNotFound(id)))
                    return
                }
                promise(.success(list))
            }
        }
    }

    func update(list: List) {
        logger.info("Called \(#function) with list id \(list.id)")
        var lists = localRepo.library.lists
        guard let index = lists.firstIndex(where: { $0.id == list.id }) else {
            logger.fault("List id \(list.id) does not exists")
            return
        }
        guard list != lists[index] else { return }
        lists[index] = list
        localRepo.library.lists = lists
        localRepo.recompute()
        sync()
    }

    func move(listsFrom source: IndexSet, to destination: Int) {
        let set = NSMutableOrderedSet(array: localRepo.library.lists)
        set.moveObjects(at: source, to: destination)
        localRepo.library.lists = set.array as! [List]
        sync()
    }

    func remove(listWithId id: Int) {
        logger.info("Called \(#function) with list id \(id)")
        guard let index = localRepo.library.lists.firstIndex(where: { $0.id == id }) else {
            logger.fault("List id \(id) does not exists")
            return
        }
        localRepo.library.lists.remove(at: index)
        localRepo.recompute()
        sync()
    }

    func move(categoriesInListWithId id: Int, from source: IndexSet, to destination: Int) {
        logger.info("Called \(#function) with list id \(id), source \(source), destination \(destination)")
        guard let index = localRepo.library.lists.firstIndex(where: { $0.id == id }) else {
            logger.fault("List id \(id) does not exists")
            return
        }
        var list = localRepo.library.lists[index]
        let set = NSMutableOrderedSet(array: list.categoryIds)
        set.moveObjects(at: source, to: destination)
        list.categoryIds = set.array as! [Int]
        localRepo.library.lists[index] = list
        sync()
    }

    func create(list unidentifiedList: List) -> List {
        logger.info("Called \(#function)")
        let sequence = localRepo.library.sequence
        localRepo.library.sequence += 1
        var identifiedList = unidentifiedList
        identifiedList.id = sequence
        localRepo.library.lists.insert(identifiedList, at: 0)
        return identifiedList
    }

    func create(category: Entities.Category, forListWithId id: Int) {
        logger.info("Called \(#function) with list id \(id)")
        guard let index = localRepo.library.lists.firstIndex(where: { $0.id == id }) else {
            logger.fault("List id \(id) does not exists")
            return
        }
        var list = localRepo.library.lists[index]
        let category = create(category: category)
        list.categoryIds.append(category.id)
        localRepo.library.lists[index] = list
        localRepo.recompute()
        sync()
    }
}

public extension Repository {
    func get(listWithId id: Int) -> List? {
        logger.info("Called \(#function) with list id \(id)")
        let lists = localRepo.library.lists
        guard let index = lists.firstIndex(where: { $0.id == id }) else {
            logger.fault("List id \(id) does not exists")
            return nil
        }
        return lists[index]
    }
}
