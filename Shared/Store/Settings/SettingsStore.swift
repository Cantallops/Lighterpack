import Foundation
import Combine
import SwiftUI

final class SettingsStore: ObservableObject {
    @AppSetting(.showWorn) var showWorn
    @AppSetting(.showPrice) var showPrice
    @AppSetting(.showImages) var showImages
    @AppSetting(.showConsumable) var showConsumable
    @AppSetting(.showListDescription) var showListDescription
    @AppSetting(.showSidebar) var showSidebar
    @AppSetting(.currencySymbol) var currencySymbol
    @AppSetting(.itemUnit) var itemUnit
    @AppSetting(.totalUnit) var totalUnit
    @AppSetting(.defaultListId) var defaultListId
    @AppSetting(.sequence) var sequence

    init(userDefaults: UserDefaults = .standard) {
        _showWorn = .init(.showWorn, store: userDefaults)
        _showPrice = .init(.showPrice, store: userDefaults)
        _showImages = .init(.showImages, store: userDefaults)
        _showConsumable = .init(.showConsumable, store: userDefaults)
        _showListDescription = .init(.showListDescription, store: userDefaults)
        _showSidebar = .init(.showSidebar, store: userDefaults)
        _currencySymbol = .init(.currencySymbol, store: userDefaults)
        _itemUnit = .init(.itemUnit, store: userDefaults)
        _totalUnit = .init(.totalUnit, store: userDefaults)
        _defaultListId = .init(.defaultListId, store: userDefaults)
        _sequence = .init(.sequence, store: userDefaults)
    }
}

extension AppSettingKey {
    static var showWorn: AppSettingKey<Bool> { .init(key: #function, defaultValue: true) }
    static var showPrice: AppSettingKey<Bool> { .init(key: #function, defaultValue: true) }
    static var showImages: AppSettingKey<Bool> { .init(key: #function, defaultValue: true) }
    static var showConsumable: AppSettingKey<Bool> { .init(key: #function, defaultValue: true) }
    static var showListDescription: AppSettingKey<Bool> { .init(key: #function, defaultValue: true) }
    static var showSidebar: AppSettingKey<Bool> { .init(key: #function, defaultValue: true) }
    static var currencySymbol: AppSettingKey<String> { .init(key: #function, defaultValue: "$") }
    static var itemUnit: AppSettingKey<WeightUnit> { .init(key: #function, defaultValue: .g) }
    static var totalUnit: AppSettingKey<WeightUnit> { .init(key: #function, defaultValue: .g) }
    static var defaultListId: AppSettingKey<Int> { .init(key: #function, defaultValue: 0) }
    static var sequence: AppSettingKey<Int> { .init(key: #function, defaultValue: 0) }
}
