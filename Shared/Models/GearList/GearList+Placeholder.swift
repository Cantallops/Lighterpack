import Foundation

extension GearList {
    static var placeholder: GearList = .init(
        id: -1,
        name: "List's name",
        categoryIds: [],
        description: "Description list, Description list, Description list, Description list, Description list,",
        externalId: "",
        totalWeight: 200,
        totalWornWeight: 200,
        totalConsumableWeight: 300,
        totalBaseWeight: 300,
        totalPackWeight: 200,
        totalPrice: 200,
        totalConsumablePrice: 200,
        totalWornPrice: 200,
        totalQty: 100
    )

    var isPlaceholder: Bool { self.id == GearList.placeholder.id }
}
