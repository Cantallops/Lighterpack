import Foundation
import Combine

final class SettingsStore: ObservableObject {
    let objectWillChange = PassthroughSubject<Void, Never>()

    var totalUnit: WeigthUnit {
        get { WeigthUnit(rawValue: _totalUnit) ?? .oz }
        set { _totalUnit = newValue.rawValue }
    }
    @UserDefault(.totalUnit, defaultValue: "oz") private var _totalUnit: String
    var itemUnit: WeigthUnit {
        get { WeigthUnit(rawValue: _itemUnit) ?? .oz }
        set { _itemUnit = newValue.rawValue }
    }
    @UserDefault(.itemUnit, defaultValue: "oz") private var _itemUnit: String
    @UserDefault(.defaultListId, defaultValue: 1) var defaultListId: Int
    @UserDefault(.sequence, defaultValue: 0) var sequence: Int
    @UserDefault(.showSidebar, defaultValue: false) var showSidebar: Bool
    @UserDefault(.currencySymbol, defaultValue: "$") var currencySymbol: String
    @UserDefault(.optionalFieldImages, defaultValue: false) var images: Bool
    @UserDefault(.optionalFieldPrice, defaultValue: false) var price: Bool
    @UserDefault(.optionalFieldWorn, defaultValue: true) var worn: Bool
    @UserDefault(.optionalFieldConsumable, defaultValue: true) var consumable: Bool
    @UserDefault(.optionalFieldListDescription, defaultValue: false) var listDescription: Bool

    private var didChangeCancellable: AnyCancellable?

    init() {
        didChangeCancellable = NotificationCenter.default
            .publisher(for: UserDefaults.didChangeNotification)
            .map { _ in () }
            .receive(on: DispatchQueue.main)
            .subscribe(objectWillChange)
    }
}
