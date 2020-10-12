import SwiftUI

struct CategoryItemCell: View {
    @EnvironmentObject var libraryStore: LibraryStore
    @EnvironmentObject var settingsStore: SettingsStore
    private var totalUnit: WeightUnit { settingsStore.totalUnit }
    private var currencySymbol: String { settingsStore.currencySymbol }
    private var showWorn: Bool { settingsStore.worn }
    private var showPrice: Bool { settingsStore.price }
    private var showImages: Bool { settingsStore.images }
    private var showConsumable: Bool { settingsStore.consumable }

    var categoryItem: CategoryItem
    var category: Category
    var list: GearList
    var onMove: (Category, Category) -> Void
    var item: Item? { libraryStore.item(withId: categoryItem.itemId) }

    @State private var modifableCategoryItem: CategoryItem = .placeholder

    init(categoryItem: CategoryItem, in category: Category, of list: GearList, onMove: @escaping (Category, Category) -> Void) {
        self.categoryItem = categoryItem
        self.category = category
        self.list = list
        self.onMove = onMove
    }

    var body: some View {
        if let item = item {
            HStack {
                if let url = item.fullImageURL, showImages {
                    NetworkImage(url: url)
                        .frame(width: 60, height: 60)
                        .cornerRadius(4)
                }
                VStack(alignment: .leading) {
                    Text(item.name)
                    HStack {
                        if modifableCategoryItem.star != .none {
                            Icon(.star)
                                .foregroundColor(modifableCategoryItem.star.color)
                        }
                        if !item.url.isEmpty {
                            Icon(.link)
                        }
                        if modifableCategoryItem.worn && showWorn {
                            Icon(.worn)
                        }
                        if modifableCategoryItem.consumable && showConsumable {
                            Icon(.consumable)
                        }
                    }.font(.caption)
                    Text(item.description)
                        .font(.footnote)
                        .lineLimit(2)
                        .foregroundColor(Color(.secondaryLabel))
                }
                Spacer()
                HStack {
                    VStack(alignment: .trailing) {
                        if showPrice {
                            Text(item.price.formattedPrice(currencySymbol))
                        }
                        Text(item.formattedWeight)
                    }
                    .foregroundColor(Color(.tertiaryLabel))
                    HStack(alignment: .lastTextBaseline, spacing: 0) {
                        Icon(.quantity)
                            .font(.caption)
                        Text(String(modifableCategoryItem.qty))
                            .font(.title3)
                    }
                }
            }
            .contextMenu(menuItems: { contextMenu })
            .onAppear {
                if modifableCategoryItem.isPlaceholder {
                    modifableCategoryItem = categoryItem
                }
            }.onChange(of: modifableCategoryItem) { categoryItem in
                libraryStore.replace(categoryItem: categoryItem, in: category)
            }
        }
    }

    @ViewBuilder
    private var contextMenu: some View {
        Menu("Move to...") {
            ForEach(libraryStore.categories(ofList: list)) { cat in
                Button {
                    onMove(category, cat)
                } label: {
                    Text(cat.name)
                }
            }

        }
        Divider()
        Group {
            if modifableCategoryItem.qty < Int.max {
                Button {
                    modifableCategoryItem.qty += 1
                } label: {
                    Label("Increment", icon: .add)
                }
            }
            if modifableCategoryItem.qty > 0 {
                Button {
                    modifableCategoryItem.qty -= 1
                } label: {
                    Label("Decrement", icon: .remove)
                }
            }
        }
        Divider()
        Group {
            Toggle(isOn: $modifableCategoryItem.worn) {
                Label("Worn", icon: .worn)
            }
            Toggle(isOn: $modifableCategoryItem.consumable) {
                Label("Consumable", icon: .consumable)
            }
            Menu {
                Picker(selection: $modifableCategoryItem.star, label: Text("Star")) {
                    ForEach(StarColor.allCases, id: \.rawValue) {
                        Label($0.title, icon: .star)
                            .tag($0)
                            .foregroundColor($0.color)
                    }
                }
            } label: {
                Label("Star...", icon: .star)
            }
        }
        Divider()
        Button(action: {
            remove(categoryItems: [modifableCategoryItem])
        }, label: {
            Label("Delete", icon: .delete)
        })
    }


    func remove(categoryItems: [CategoryItem]) {
        libraryStore.remove(categoryItems: categoryItems, in: category)
    }
}

extension StarColor {
    var color: Color {
        switch self {
        case .none: return .clear
        case .yellow: return .init(.systemYellow)
        case .red: return .init(.systemRed)
        case .green: return .init(.systemGreen)
        }
    }
}
/*
struct CategoryItemCell_Previews: PreviewProvider {
    static var previews: some View {
        CategoryItemCell()
    }
}*/
