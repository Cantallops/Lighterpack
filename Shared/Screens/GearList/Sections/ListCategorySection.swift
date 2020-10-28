import SwiftUI
import Entities
import DesignSystem
import Repository

struct GearListCategorySection: View {
    @EnvironmentObject var repository: Repository

    @Binding var category: Entities.Category

    var body: some View {
        Section(header: EditableSectionHeader(title: $category.name, placeholder: "Category", detail: {
            Button(action: {
                repository.remove(categoryWithId: category.id)
            }) {
                Icon(.remove)
            }.foregroundColor(Color(.systemRed))
        })) {
            ForEach(category.categoryItems) { (item: CategoryItem) in
                CategoryItemCell(categoryItem: repository.binding(forCategoryItem: item, in: category))
            }
            .onDelete(perform: remove)
            DisclosureGroup {
                if repository.showWorn {
                    resumeCell(
                        title: "Worn",
                        icon: .worn,
                        price: category.subtotalWornPrice,
                        weight: category.subtotalWornWeight,
                        quantity: category.subtotalWornQty
                    )
                }
                if repository.showConsumable {
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
        category.categoryItems.remove(atOffsets: indexSet)
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
                if repository.showPrice {
                    Text(price.formattedPrice(repository.currencySymbol)).frame(minWidth: 0, maxWidth: .infinity)
                }
                Text(weight.formattedWeight(repository.totalUnit)).frame(minWidth: 0, maxWidth: .infinity)
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
