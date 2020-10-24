import SwiftUI

struct GearListCategorySection: View {
    @EnvironmentObject var libraryStore: LibraryStore

    @AppSetting(.totalUnit) private var totalUnit: WeightUnit
    @AppSetting(.currencySymbol) private var currencySymbol: String
    @AppSetting(.showWorn) private var showWorn: Bool
    @AppSetting(.showPrice) private var showPrice: Bool
    @AppSetting(.showConsumable) private var showConsumable: Bool
    

    @Binding var category: Category
    var list: GearList

    var body: some View {
        Section(header: EditableSectionHeader(title: $category.name, placeholder: "Category", detail: {
            Button(action: {
                libraryStore.remove(category: category)
            }) {
                Icon(.remove)
            }.foregroundColor(Color(.systemRed))
        })) {
            ForEach(category.categoryItems) { (item: CategoryItem) in
                CategoryItemCell(categoryItem: libraryStore.binding(forCategoryItem: item, in: category))
            }
            .onDelete(perform: remove)
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

    func remove(indexSet: IndexSet) {
        let categoryItems = indexSet.map { category.categoryItems[$0] }
        libraryStore.remove(categoryItems: categoryItems, in: category)
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
