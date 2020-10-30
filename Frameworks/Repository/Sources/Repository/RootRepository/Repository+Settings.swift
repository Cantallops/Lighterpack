import Foundation
import Entities

public extension Repository {
    var currencySymbol: String {
        get { localRepo.library.currencySymbol }
        set {
            logger.info("Set \(#function) \(newValue)")
            localRepo.library.currencySymbol = newValue
            sync()
        }
    }
    var itemUnit: WeightUnit {
        get { localRepo.library.itemUnit }
        set {
            logger.info("Set \(#function) \(newValue.rawValue)")
            localRepo.library.itemUnit = newValue
            sync()
        }
    }
    var totalUnit: WeightUnit {
        get { localRepo.library.totalUnit }
        set {
            logger.info("Set \(#function) \(newValue.rawValue)")
            localRepo.library.totalUnit = newValue
            sync()
        }
    }
    var showPrice: Bool {
        get { localRepo.library.optionalFields.price }
        set {
            logger.info("Set \(#function) \(newValue)")
            localRepo.library.optionalFields.price = newValue
            sync()
        }
    }
    var showWorn: Bool {
        get { localRepo.library.optionalFields.worn }
        set {
            logger.info("Set \(#function) \(newValue)")
            localRepo.library.optionalFields.worn = newValue
            sync()
        }
    }
    var showImages: Bool {
        get { localRepo.library.optionalFields.images }
        set {
            logger.info("Set \(#function) \(newValue)")
            localRepo.library.optionalFields.images = newValue
            sync()
        }
    }
    var showConsumable: Bool {
        get { localRepo.library.optionalFields.consumable }
        set {
            logger.info("Set \(#function) \(newValue)")
            localRepo.library.optionalFields.consumable = newValue
            sync()
        }
    }
    var showListDescription: Bool {
        get { localRepo.library.optionalFields.listDescription }
        set {
            logger.info("Set \(#function) \(newValue)")
            localRepo.library.optionalFields.listDescription = newValue
            sync()
        }
    }
}
