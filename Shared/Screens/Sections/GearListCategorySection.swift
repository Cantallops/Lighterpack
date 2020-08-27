import SwiftUI

struct GearListCategorySection: View {

    @EnvironmentObject var settingsStore: SettingsStore
    private var totalUnit: WeigthUnit { settingsStore.totalUnit }
    private var currencySymbol: String { settingsStore.currencySymbol }
    private var showWorn: Bool { settingsStore.worn }
    private var showPrice: Bool { settingsStore.price }
    private var showConsumable: Bool { settingsStore.consumable }

    var category: Category

    var body: some View {
        Section(header: SectionHeader(title: category.name)) {
            ForEach(category.categoryItems) { (item: CategoryItem) in
                CategoryItemCell(categoryItem: item)
            }
            DisclosureGroup {
                if showWorn {
                    resumeCell(
                        title: "Worn",
                        icon: .worn,
                        price: category.subtotalWornPrice,
                        weight: category.subtotalWornWeight,
                        quantity: category.subtotalWornQty
                    )
                }
                if showConsumable {
                    resumeCell(
                        title: "Cons.",
                        icon: .consumable,
                        price: category.subtotalConsumablePrice,
                        weight: category.subtotalConsumableWeight,
                        quantity: category.subtotalConsumableQty
                    )
                }
                resumeCell(
                    title: "Base",
                    icon: .baseWeight,
                    price: category.subtotalPrice - category.subtotalConsumablePrice,
                    weight: category.subtotalWeight - category.subtotalConsumableWeight,
                    quantity: category.subtotalQty - category.subtotalConsumableQty
                )
            } label: {
                resumeCell(
                    title: "Total",
                    price: category.subtotalPrice,
                    weight: category.subtotalWeight,
                    quantity: category.subtotalQty,
                    titleWeight: .bold
                )
            }
        }
    }

    func resumeCell(title: String, icon: Icon.Token? = nil, price: Float, weight: Float, quantity: Int, titleWeight: Font.Weight? = nil) -> some View {
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
