import Entities

struct Library: Codable {
    let version: String
    let totalUnit: WeightUnit
    let itemUnit: WeightUnit
    let defaultListId: Int
    let sequence: Int
    let showSidebar: Bool
    let currencySymbol: String
    let items: [Item]
    let categories: [Entities.Category]
    let lists: [List]
    let optionalFields: OptionalFields
}

struct OptionalFields: Codable {
    let images: Bool
    let price: Bool
    let worn: Bool
    let consumable: Bool
    let listDescription: Bool
}
