import SwiftUI
import Entities
import DesignSystem
import Repository

struct ListCategorySection: View {
    @EnvironmentObject var repository: Repository
    @Environment(\.redactionReasons) private var redactionReasons

    @Binding var category: Entities.Category

    var body: some View {
        Section(
            header: EditableSectionHeader(
                title: $category.name,
                placeholder: "Category",
                leadingDetail: {
                    if redactionReasons.isEmpty {
                        ColorPicker(
                            selection: .init(
                                get: { Color(category.color) ?? .clear },
                                set: { category.color = $0.categoryColor }
                            ),
                            supportsOpacity: false
                        ) { EmptyView() }
                        .fixedSize()
                    } else {
                        Icon(.categoryDot)
                            .foregroundColor(.systemGray3)
                            .unredacted()
                    }
                },
                detail: {
                    Button(action: {
                        repository.remove(categoryWithId: category.id)
                    }) {
                        Icon(.remove)
                    }
                    .foregroundColor(.systemRed)
                    .unredacted()
                }
            )
        ) {
            ForEach(category.categoryItems) { (item: CategoryItem) in
                CategoryItemCell(categoryItem: repository.binding(forCategoryItem: item, in: category))
            }
            .onDelete(perform: remove)
            Button(action: {}) {
                Button(action: {}, label: {
                    Label("Add new item", icon: .add)
                })
            }
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
            }.unredacted()
        }.disabled(!redactionReasons.isEmpty)
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
                        .redacted(reason: redactionReasons)
                }
                Text(weight.formattedWeight(repository.totalUnit)).frame(minWidth: 0, maxWidth: .infinity)
                    .redacted(reason: redactionReasons)
                HStack(alignment: .lastTextBaseline, spacing: 0) {
                    Text(String("𝗑\(quantity)"))
                        .redacted(reason: redactionReasons)
                }.frame(minWidth: 0, maxWidth: 30)
            }
            .frame(maxWidth: 200)
        }
    }
}
