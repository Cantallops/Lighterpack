import Foundation
import CoreData
import Combine

class SyncEngine {
    var lighterPackAccess: LighterPackAccess = .init()
    var settings: SettingsProtocol = Settings()
    var syncContext: NSPersistentContainer = PersistentContainer.persistentContainer

    enum Status {
        case running(AnyCancellable)
        case error(Error)
        case idle
    }

    var status: Status = .idle

    func run() {
        if case let .running(cancellable) = status {
            cancellable.cancel()
        }
        let anyCancellable = lighterPackAccess.request(RetrieveInfoEndpoint())
            .sink(receiveCompletion: { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .finished:
                    self.status = .idle
                case .failure(let error):
                    self.status = .error(error)
                }
            }, receiveValue: { [weak self] result in
                do {
                    try self?.sync(result)
                } catch let error as NSError {
                    print(error)
                }
            })
        self.status = .running(anyCancellable)
    }

    private func sync(_ data: LighterPackResponse) throws {
        settings.username = data.username
        settings.syncToken = data.syncToken
        let data = data.library.data(using: .utf8)!
        let library = try JSONDecoder().decode(Library.self, from: data)

        settings.version = library.version
        settings.totalUnit = library.totalUnit
        settings.itemUnit = library.itemUnit
        settings.defaultListId = library.defaultListId
        settings.sequence = library.sequence
        settings.showSidebar = library.showSidebar
        settings.currencySymbol = library.currencySymbol

        settings.consumable = library.optionalFields.consumable
        settings.worn = library.optionalFields.worn
        settings.images = library.optionalFields.images
        settings.listDescription = library.optionalFields.listDescription
        settings.price = library.optionalFields.price

        syncContext.performBackgroundTask { context in
            do {
                try SyncEngine.cleanDB(context: context)
                let items = try SyncEngine.sync(library.items, context: context)
                let categories = try SyncEngine.sync(library.categories, dependency: items, context: context)
                _ = try SyncEngine.sync(library.lists, dependency: categories, context: context)
                try context.save()
            } catch {
                print(error)
            }
        }
    }

    private static func cleanDB(context: NSManagedObjectContext) throws {
        let listsFetchRequest: NSFetchRequest<NSFetchRequestResult> = DBList.fetchRequest()
        let itemsFetchRequest: NSFetchRequest<NSFetchRequestResult> = DBItem.fetchRequest()
        let lists = try context.fetch(listsFetchRequest) as! [NSManagedObject]
        let items = try context.fetch(itemsFetchRequest) as! [NSManagedObject]
        lists.forEach { context.delete($0) }
        items.forEach { context.delete($0) }
        /* This causes SwiftUI to show double
        let listsDeleteRequest = NSBatchDeleteRequest(fetchRequest: listsFetchRequest)
        let itemsDeleteRequest = NSBatchDeleteRequest(fetchRequest: itemsFetchRequest)
        try context.execute(listsDeleteRequest)
        try context.execute(itemsDeleteRequest)
         */
    }

    private static func sync(_ items: [Item], context: NSManagedObjectContext) throws -> [DBItem] {
        return items.map { item in
            let dbItem = DBItem(context: context)
            dbItem.authorUnit = item.authorUnit.rawValue
            dbItem.desc = item.description
            dbItem.id = Int64(item.id)
            dbItem.image = item.image
            dbItem.imageURL = item.imageUrl
            dbItem.name = item.name
            dbItem.price = item.price
            dbItem.weight = item.weight
            dbItem.url = item.url
            return dbItem
        }
    }

    private static func sync(_ categories: [Category], dependency: [DBItem], context: NSManagedObjectContext) throws -> [DBCategory] {
        return categories.map { category in
            let dbCategory = DBCategory(context: context)
            dbCategory.name = category.name
            dbCategory.id = Int64(category.id)
            let color = category.color
            dbCategory.hexColor = String(format:"%02X", Int(color?.r ?? 0)) + String(format:"%02X", Int(color?.g ?? 0)) + String(format:"%02X", Int(color?.b ?? 0))

            for categoryItem in category.categoryItems {
                guard let item = dependency.first(where: { $0.id == Int64(categoryItem.itemId)}) else {
                    continue
                }
                let dbCategoryItem = DBCategoryItem(context: context)
                dbCategoryItem.consumable = categoryItem.consumable
                dbCategoryItem.item = item
                dbCategoryItem.quantity = Int16(categoryItem.qty)
                dbCategoryItem.star = Int16(categoryItem.star)
                dbCategoryItem.worn = categoryItem.worn

                dbCategory.addToItems(dbCategoryItem)
            }
            return dbCategory
        }
    }

    private static func sync(_ lists: [GearList], dependency: [DBCategory], context: NSManagedObjectContext) throws -> [DBList] {
        var dbLists: [DBList] = []
        for list in lists {
            let dbList = DBList(context: context)
            dbList.id = Int64(list.id)
            dbList.desc = list.description
            dbList.name = list.name
            dbList.externalId = list.externalId
            dbList.order = Int16(dbLists.count)
            // To maintain the order is not possible to use filter
            for categoryId in list.categoryIds {
                guard let category = dependency.first(where: { $0.id == categoryId }) else { continue }
                dbList.addToCategories(category)
            }
            dbLists.append(dbList)
        }
        return dbLists
    }
}
