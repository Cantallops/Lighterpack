import Foundation

extension Category {
    static let placeholder: Category = Category(id: -1, name: "", categoryItems: [], subtotalWeight: 0, subtotalWornWeight: 0, subtotalConsumableWeight: 0, subtotalPrice: 0, subtotalWornPrice: 0, subtotalConsumablePrice: 0, subtotalQty: 0, subtotalWornQty: 0, subtotalConsumableQty: 0, activeHover: nil, displayColor: nil, color: nil)

    var isPlaceholder: Bool { self.id == Category.placeholder.id }
}
