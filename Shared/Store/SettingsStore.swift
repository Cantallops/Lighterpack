import Foundation
import Combine

final class SettingsStore: ObservableObject {
    private let userDefaults: UserDefaults
    
    @Published var totalUnit: WeigthUnit = .oz {
        didSet {
            userDefaults[SettingKey.totalUnit] = totalUnit
        }
    }
    @Published var itemUnit: WeigthUnit = .oz {
        didSet {
            userDefaults[SettingKey.itemUnit] = itemUnit
        }
    }
    @Published var defaultListId: Int = 0 {
        didSet {
            userDefaults[SettingKey.defaultListId] = defaultListId
        }
    }
    @Published var sequence: Int = 0 {
        didSet {
            userDefaults[SettingKey.sequence] = sequence
        }
    }
    @Published var showSidebar: Bool = false {
        didSet {
            userDefaults[SettingKey.showSidebar] = showSidebar
        }
    }
    @Published var currencySymbol: String = "$" {
        didSet {
            userDefaults[SettingKey.currencySymbol] = currencySymbol
        }
    }
    @Published var images: Bool = false {
        didSet {
            userDefaults[SettingKey.optionalFieldImages] = images
        }
    }
    @Published var price: Bool = true {
        didSet {
            userDefaults[SettingKey.optionalFieldPrice] = price
        }
    }
    @Published var worn: Bool = true {
        didSet {
            userDefaults[SettingKey.optionalFieldWorn] = worn
        }
    }
    @Published var consumable: Bool = true {
        didSet {
            userDefaults[SettingKey.optionalFieldConsumable] = consumable
        }
    }
    @Published var listDescription: Bool = true {
        didSet {
            userDefaults[SettingKey.optionalFieldListDescription] = listDescription
        }
    }

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
        self.totalUnit = userDefaults[SettingKey.totalUnit] ?? .oz
        self.itemUnit = userDefaults[SettingKey.itemUnit] ?? .oz
        self.defaultListId = userDefaults[SettingKey.defaultListId] ?? 0
        self.sequence = userDefaults[SettingKey.sequence] ?? 0
        self.showSidebar = userDefaults[SettingKey.showSidebar] ?? true
        self.currencySymbol = userDefaults[SettingKey.currencySymbol] ?? "$"
        self.images = userDefaults[SettingKey.optionalFieldImages] ?? true
        self.price = userDefaults[SettingKey.optionalFieldPrice] ?? true
        self.worn = userDefaults[SettingKey.optionalFieldWorn] ?? true
        self.consumable = userDefaults[SettingKey.optionalFieldConsumable] ?? true
        self.listDescription = userDefaults[SettingKey.optionalFieldListDescription] ?? true
    }
}
