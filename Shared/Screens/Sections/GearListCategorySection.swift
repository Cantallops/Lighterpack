import SwiftUI

struct GearListCategorySection: View {
    @EnvironmentObject var libraryStore: LibraryStore
    @EnvironmentObject var settingsStore: SettingsStore
    private var totalUnit: WeightUnit { settingsStore.totalUnit }
    private var currencySymbol: String { settingsStore.currencySymbol }
    private var showWorn: Bool { settingsStore.worn }
    private var showPrice: Bool { settingsStore.price }
    private var showConsumable: Bool { settingsStore.consumable }

    var category: Category
    var list: GearList
    @State private var modifableCategory: Category = .placeholder

    var body: some View {
        Section(header: EditableSectionHeader(title: $modifableCategory.name, placeholder: "Category", detail: {
            Button(action: {
                libraryStore.remove(category: category)
            }) {
                Icon(.remove)
            }.foregroundColor(Color(.systemRed))
        })) {
            ForEach(modifableCategory.categoryItems) { (item: CategoryItem) in
                CategoryItemCell(categoryItem: item, in: modifableCategory, of: list) { (source, dest) in
                    libraryStore.remove(categoryItems: [item], in: source)
                    libraryStore.replace(categoryItem: item, in: dest)
                }
            }
            .onDelete(perform: remove)
            DisclosureGroup {
                if showWorn {
                    resumeCell(
                        title: "Worn",
                        icon: .worn,
                        price: modifableCategory.subtotalWornPrice,
                        weight: modifableCategory.subtotalWornWeight,
                        quantity: modifableCategory.subtotalWornQty
                    )
                }
                if showConsumable {
                    resumeCell(
                        title: "Cons.",
                        icon: .consumable,
                        price: modifableCategory.subtotalConsumablePrice,
                        weight: modifableCategory.subtotalConsumableWeight,
                        quantity: modifableCategory.subtotalConsumableQty
                    )
                }
                resumeCell(
                    title: "Base",
                    icon: .baseWeight,
                    price: modifableCategory.subtotalPrice - modifableCategory.subtotalConsumablePrice,
                    weight: modifableCategory.subtotalWeight - modifableCategory.subtotalConsumableWeight,
                    quantity: modifableCategory.subtotalQty - modifableCategory.subtotalConsumableQty
                )
            } label: {
                resumeCell(
                    title: "Total",
                    price: modifableCategory.subtotalPrice,
                    weight: modifableCategory.subtotalWeight,
                    quantity: modifableCategory.subtotalQty,
                    titleWeight: .bold
                )
            }
        }
        .onAppear {
            if modifableCategory.isPlaceholder {
                modifableCategory = category
            }
        }.onChange(of: modifableCategory) { category in
            libraryStore.replace(category: category)
        }
    }

    func remove(indexSet: IndexSet) {
        let categoryItems = indexSet.map { modifableCategory.categoryItems[$0] }
        libraryStore.remove(categoryItems: categoryItems, in: modifableCategory)
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
