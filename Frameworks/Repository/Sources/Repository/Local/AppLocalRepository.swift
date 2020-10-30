import Foundation
import Entities
import Combine
import os.log

extension Logger {
    private static var subsystem = Bundle.main.bundleIdentifier!

    static let localRepo = Logger(subsystem: subsystem, category: "LocalRepository")
}

public class AppLocalRepository: LocalRepository, ObservableObject {
    private enum LocalKeys: String {
        case username
        case library
        case originalLibrary
        case syncToken
        case cookie
    }
    private let logger: Logger = .localRepo
    private let userDefaults: UserDefaults

    @Published public var username: String {
        didSet {
            logger.info("Saving \(#function) \(self.username, privacy: .private(mask: .hash))")
            // TODO Save in keychain
            userDefaults.set(username, forKey: LocalKeys.username.rawValue)
        }
    }
    @Published public var library: Library {
        didSet {
            let encoder = JSONEncoder()
            guard let encoded = try? encoder.encode(library) else {
                logger.info("Removing \(#function)")
                userDefaults.removeObject(forKey: LocalKeys.library.rawValue)
                return
            }
            logger.info("Saving \(#function)")
            userDefaults.set(encoded, forKey: LocalKeys.library.rawValue)
        }
    }
    @Published public var originalLibrary: Library? {
        didSet {
            let encoder = JSONEncoder()
            guard
                let library = originalLibrary,
                let encoded = try? encoder.encode(library) else {
                logger.info("Removing \(#function)")
                userDefaults.removeObject(forKey: LocalKeys.originalLibrary.rawValue)
                return
            }
            logger.info("Saving \(#function)")
            userDefaults.set(encoded, forKey: LocalKeys.originalLibrary.rawValue)
        }
    }
    @Published public var syncToken: Int = 0 {
        didSet {
            logger.info("Saving \(#function) \(self.syncToken)")
            userDefaults.set(syncToken, forKey: LocalKeys.syncToken.rawValue)
        }
    }
    @Published public var cookie: String? {
        didSet {
            logger.info("Saving \(#function) \(self.cookie ?? "", privacy: .private(mask: .hash))")
            // TODO Save in keychain
            userDefaults.set(cookie, forKey: LocalKeys.cookie.rawValue)
        }
    }

    public init(
        userDefaults: UserDefaults = .standard
    ) {
        self.userDefaults = userDefaults
        self.username = userDefaults.string(forKey: LocalKeys.username.rawValue) ?? ""
        self.syncToken = userDefaults.integer(forKey: LocalKeys.syncToken.rawValue)
        self.cookie = userDefaults.string(forKey: LocalKeys.cookie.rawValue)
        self.library = AppLocalRepository.loadLibrary(from: userDefaults, key: LocalKeys.library.rawValue) ?? .placeholder
        self.originalLibrary = AppLocalRepository.loadLibrary(from: userDefaults, key: LocalKeys.originalLibrary.rawValue)
    }

    public func recompute() {
        logger.info("Recomputing library")
        library = recompute(library: library)
    }
}

private extension AppLocalRepository {
    static func loadLibrary(from userDefaults: UserDefaults, key: String) -> Library? {
        guard let data = userDefaults.data(forKey: key) else { return nil }
        let decoder = JSONDecoder()
        return try? decoder.decode(Library.self, from: data)
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
