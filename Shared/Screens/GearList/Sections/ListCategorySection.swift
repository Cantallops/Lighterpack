import SwiftUI
import Entities
import DesignSystem
import Repository

struct ListCategorySection: View {
    @EnvironmentObject var repository: Repository
    @Environment(\.redactionReasons) private var redactionReasons
    @State private var showDeleteAlert: Bool = false
    @State private var showAddNewItem: Bool = false

    @Binding var category: Entities.Category
    let listId: Int

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
                    Button(action: { showDeleteAlert = true }) {
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
            Button(action: { showAddNewItem = true }, label: {
                Label("Add new item", icon: .add)
            })
            .sheet(isPresented: $showAddNewItem) {
                NewItemSelectorView(category: $category, invalidIds: repository.invalidItemIds(forListId: listId))
                    .environmentObject(repository)
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
        }
        .disabled(!redactionReasons.isEmpty)
        .alert(isPresented: $showDeleteAlert) {
            Alert(
                title: Text("Delete \(category.name)"),
                message: Text("Are you sure you want to remove \(category.name)?\nThis can't be undone."),
                primaryButton: .cancel() {},
                secondaryButton: .destructive(Text("Delete")) {
                    repository.remove(categoryWithId: category.id)
                }
            )
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

struct NewItemSelectorView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var repository: Repository
    @Binding var category: Entities.Category
    var invalidIds: [Int]

    var body: some View {
        NavigationView {
            SwiftUI.List {
                ForEach(repository.getAllItems().filter { !invalidIds.contains($0.id) }) { (item: Item) in
                    Button(action: {
                        var editedCategory = category
                        editedCategory.categoryItems.append(.init(qty: 1, worn: false, consumable: false, star: .none, itemId: item.id, price: item.price, weight: item.weight))
                        repository.update(category: editedCategory)
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        ItemCell(
                            item: item,
                            currencySymbol: repository.currencySymbol,
                            showPrice: repository.showPrice,
                            showImages: repository.showImages
                        )
                    })
                    .accentColor(.label)
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Select gear")
            .navigationBarItems(
                trailing: Button(
                    action: { presentationMode.wrappedValue.dismiss() },
                    label: {
                        Icon(.close)
                    }))
        }
    }
}

private extension Repository {
    func invalidItemIds(forListId id: Int) -> [Int] {
        guard let list: Entities.List = get(listWithId: id) else {
            return []
        }

        let categories: [Entities.Category] = list.categoryIds.compactMap {
            get(categoryWithId: $0)
        }

        return categories.flatMap { $0.categoryItems }.map { $0.id }
    }
}
