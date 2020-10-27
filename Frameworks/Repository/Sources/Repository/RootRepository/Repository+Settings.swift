import Foundation
import Entities

public extension Repository {
    var currencySymbol: String {
        get { localRepo.library.currencySymbol }
        set {
            localRepo.library.currencySymbol = newValue
            sync()
        }
    }
    var itemUnit: WeightUnit {
        get { localRepo.library.itemUnit }
        set {
            localRepo.library.itemUnit = newValue
            sync()
        }
    }
    var totalUnit: WeightUnit {
        get { localRepo.library.totalUnit }
        set {
            localRepo.library.totalUnit = newValue
            sync()
        }
    }
    var showPrice: Bool {
        get { localRepo.library.optionalFields.price }
        set {
            localRepo.library.optionalFields.price = newValue
            sync()
        }
    }
    var showWorn: Bool {
        get { localRepo.library.optionalFields.worn }
        set {
            localRepo.library.optionalFields.worn = newValue
            sync()
        }
    }
    var showImages: Bool {
        get { localRepo.library.optionalFields.images }
        set {
            localRepo.library.optionalFields.images = newValue
            sync()
        }
    }
    var showConsumable: Bool {
        get { localRepo.library.optionalFields.consumable }
        set {
            localRepo.library.optionalFields.consumable = newValue
            sync()
        }
    }
    var showListDescription: Bool {
        get { localRepo.library.optionalFields.listDescription }
        set {
            localRepo.library.optionalFields.listDescription = newValue
            sync()
        }
    }
}
