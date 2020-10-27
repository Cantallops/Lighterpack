import Foundation

public struct Library: Codable, Equatable {
    public var version: String
    public var totalUnit: WeightUnit
    public var itemUnit: WeightUnit
    public var defaultListId: Int
    public var sequence: Int
    public var showSidebar: Bool
    public var currencySymbol: String
    public var items: [Item]
    public var categories: [Entities.Category]
    public var lists: [List]
    public var optionalFields: OptionalFields

    public init(
        version: String,
        totalUnit: WeightUnit,
        itemUnit: WeightUnit,
        defaultListId: Int,
        sequence: Int,
        showSidebar: Bool,
        currencySymbol: String,
        items: [Item],
        categories: [Entities.Category],
        lists: [List],
        optionalFields: OptionalFields
    ) {
        self.version = version
        self.totalUnit = totalUnit
        self.itemUnit = itemUnit
        self.defaultListId = defaultListId
        self.sequence = sequence
        self.showSidebar = showSidebar
        self.currencySymbol = currencySymbol
        self.items = items
        self.categories = categories
        self.lists = lists
        self.optionalFields = optionalFields
    }
}

public struct OptionalFields: Codable, Equatable {
    public var images: Bool
    public var price: Bool
    public var worn: Bool
    public var consumable: Bool
    public var listDescription: Bool

    public init(
        images: Bool = true,
        price: Bool = true,
        worn: Bool = true,
        consumable: Bool = true,
        listDescription: Bool = true
    ) {
        self.images = images
        self.price = price
        self.worn = worn
        self.consumable = consumable
        self.listDescription = listDescription
    }
}

public extension Library {
    static let placeholder: Library = .init(
        version: "placeholder",
        totalUnit: .kg,
        itemUnit: .kg,
        defaultListId: List.placeholder.id,
        sequence: 0,
        showSidebar: true,
        currencySymbol: "$",
        items: [.placeholder, .placeholder, .placeholder, .placeholder],
        categories: [.placeholder, .placeholder, .placeholder, .placeholder],
        lists: [.placeholder, .placeholder, .placeholder],
        optionalFields: .init(images: true, price: true, worn: true, consumable: true, listDescription: true)
    )

    var isPlaceholder: Bool { self.version == Library.placeholder.version }
}
