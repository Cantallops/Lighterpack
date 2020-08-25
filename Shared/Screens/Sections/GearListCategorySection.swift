import SwiftUI

struct GearListCategorySection: View {

    @AppStorage(SettingKey.totalUnit.rawValue) var totalUnit: WeigthUnit = .oz
    @AppStorage(SettingKey.currencySymbol.rawValue) var currencySymbol: String = ""

    @AppStorage(SettingKey.optionalFieldWorn.rawValue) var showWorn: Bool = true
    @AppStorage(SettingKey.optionalFieldPrice.rawValue) var showPrice: Bool = true
    @AppStorage(SettingKey.optionalFieldConsumable.rawValue) var showConsumable: Bool = true
    @Environment(\.editMode) var editMode

    @ObservedObject var category: DBCategory
    var body: some View {
        Section(
            header:
                EditableSectionHeader(
                    title: $category.name,
                    placeholder: "Category name",
                    disabled: editMode?.wrappedValue != .active
                ) {
                    if editMode?.wrappedValue == .active {
                        Button {

                        } label: {
                            Icon(.remove)
                        }
                        .font(.title2)
                        .accentColor(.init(.systemRed))
                        .foregroundColor(.init(.systemRed))
                    }
                }
        ) {
            ForEach(category.items.array as! [DBCategoryItem]) { (item: DBCategoryItem) in
                CategoryItemCell(categoryItem: item)
            }.onDelete { idx in

            }

            if editMode?.wrappedValue != .active {
                Button {

                } label: {
                    HStack {
                        Icon(.add)
                        Text("Add item")
                    }
                }
            }

            DisclosureGroup {
                if showWorn && category.wornQuantity > 0 {
                    resumeCell(
                        title: "Worn",
                        icon: .worn,
                        price: category.wornPrice,
                        weight: category.wornWeight,
                        quantity: category.wornQuantity
                    )
                }
                if showConsumable && category.consumbleQuantity > 0 {
                    resumeCell(
                        title: "Cons.",
                        icon: .consumable,
                        price: category.consumblePrice,
                        weight: category.consumbleWeight,
                        quantity: category.consumbleQuantity
                    )
                }
                if category.baseQuantity > 0 {
                    resumeCell(
                        title: "Base",
                        icon: .baseWeight,
                        price: category.basePrice,
                        weight: category.baseWeight,
                        quantity: category.baseQuantity
                    )
                }
            } label: {
                resumeCell(
                    title: "Total",
                    price: category.price,
                    weight: category.weight,
                    quantity: category.quantity,
                    titleWeight: .bold
                )
            }
        }
    }

    func resumeCell(title: String, icon: Icon.Token? = nil, price: Float, weight: Float, quantity: Int16, titleWeight: Font.Weight? = nil) -> some View {
        HStack {
            if let token = icon {
                Icon(token)
            }
            Text(title)
                .fontWeight(titleWeight)
            Spacer()
            HStack {
                if showPrice {
                    Text(price.formattedPrice(currencySymbol)).frame(minWidth: 0, maxWidth: .infinity)
                }
                Text(weight.formattedWeight(totalUnit)).frame(minWidth: 0, maxWidth: .infinity)
                HStack(alignment: .lastTextBaseline, spacing: 0) {
                    Icon(.quantity)
                        .font(.caption2)
                    Text(String(quantity))
                }.frame(minWidth: 0, maxWidth: 30)
            }
            .frame(maxWidth: 200)
        }
    }
}
