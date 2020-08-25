import Foundation

protocol SettingsProtocol {
    var username: String { get set }
    var version: String { get set }
    var totalUnit: WeigthUnit { get set }
    var itemUnit: WeigthUnit { get set }
    var defaultListId: Int { get set }
    var sequence: Int { get set }
    var showSidebar: Bool { get set }
    var currencySymbol: String { get set }
    var syncToken: Int { get set }
    var images: Bool { get set }
    var price: Bool { get set }
    var worn: Bool { get set }
    var consumable: Bool { get set }
    var listDescription: Bool { get set }
}

enum SettingKey: String {
    case username
    case backendVersion
    case totalUnit
    case itemUnit
    case defaultListId
    case sequence
    case showSidebar
    case syncToken
    case currencySymbol

    case optionalFieldImages
    case optionalFieldPrice
    case optionalFieldWorn
    case optionalFieldConsumable
    case optionalFieldListDescription
}


class Settings: SettingsProtocol {
    @UserDefault(.username, defaultValue: "") var username: String
    @UserDefault(.backendVersion, defaultValue: "0.3") var version: String
    var totalUnit: WeigthUnit {
        get { WeigthUnit(rawValue: _totalUnit) ?? .oz }
        set { _totalUnit = newValue.rawValue }
    }
    @UserDefault(.totalUnit, defaultValue: "oz") var _totalUnit: String
    var itemUnit: WeigthUnit {
        get { WeigthUnit(rawValue: _itemUnit) ?? .oz }
        set { _itemUnit = newValue.rawValue }
    }
    @UserDefault(.itemUnit, defaultValue: "oz") var _itemUnit: String
    @UserDefault(.defaultListId, defaultValue: 1) var defaultListId: Int
    @UserDefault(.sequence, defaultValue: 0) var sequence: Int
    @UserDefault(.showSidebar, defaultValue: false) var showSidebar: Bool
    @UserDefault(.currencySymbol, defaultValue: "$") var currencySymbol: String
    @UserDefault(.syncToken, defaultValue: 0) var syncToken: Int
    @UserDefault(.optionalFieldImages, defaultValue: false) var images: Bool
    @UserDefault(.optionalFieldPrice, defaultValue: false) var price: Bool
    @UserDefault(.optionalFieldWorn, defaultValue: true) var worn: Bool
    @UserDefault(.optionalFieldConsumable, defaultValue: true) var consumable: Bool
    @UserDefault(.optionalFieldListDescription, defaultValue: false) var listDescription: Bool
}

extension UserDefault {
    init(_ key: SettingKey, defaultValue: T, userDefaults: UserDefaults? = nil) {
        self.key = key.rawValue
        self.defaultValue = defaultValue
        self.userDefaults = userDefaults ?? .standard
    }
}
