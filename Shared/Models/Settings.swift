import Foundation

enum SettingKey: String {
    case username
    case backendVersion
    case sessionCookie
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



extension UserDefault {
    init(_ key: SettingKey, defaultValue: T, userDefaults: UserDefaults? = nil) {
        self.key = key.rawValue
        self.defaultValue = defaultValue
        self.userDefaults = userDefaults ?? .standard
    }
}
