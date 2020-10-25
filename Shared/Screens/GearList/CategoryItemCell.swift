import SwiftUI
import Entities
import DesignSystem

struct CategoryItemCell: View {
    @EnvironmentObject var libraryStore: LibraryStore

    @AppSetting(.totalUnit) private var totalUnit: WeightUnit
    @AppSetting(.currencySymbol) private var currencySymbol: String
    @AppSetting(.showWorn) private var showWorn: Bool
    @AppSetting(.showPrice) private var showPrice: Bool
    @AppSetting(.showImages) private var showImages: Bool
    @AppSetting(.showConsumable) private var showConsumable: Bool

    @Binding var categoryItem: CategoryItem
    var item: Item? { libraryStore.item(withId: categoryItem.itemId) }

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
                        if categoryItem.star != .none {
                            Icon(.star)
                                .foregroundColor(categoryItem.star.color)
                        }
                        if !item.url.isEmpty {
                            Icon(.link)
                        }
                        if categoryItem.worn && showWorn {
                            Icon(.worn)
                        }
                        if categoryItem.consumable && showConsumable {
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
                        Text(String(categoryItem.qty))
                            .font(.title3)
                    }
                }
            }
            .contextMenu(menuItems: { contextMenu })
        }
    }

    @ViewBuilder
    private var contextMenu: some View {

        /*Menu("Move to...") {
            ForEach(libraryStore.categories(ofList: list)) { cat in
                Button {
                    onMove(category, cat)
                } label: {
                    Text(cat.name)
                }
            }
        }
        Divider()*/
        Group {
            if categoryItem.qty < Int.max {
                Button {
                    categoryItem.qty += 1
                } label: {
                    Label("Increment", icon: .add)
                }
            }
            if categoryItem.qty > 0 {
                Button {
                    categoryItem.qty -= 1
                } label: {
                    Label("Decrement", icon: .remove)
                }
            }
        }
        Divider()
        Group {
            Toggle(isOn: $categoryItem.worn) {
                Label("Worn", icon: .worn)
            }
            Toggle(isOn: $categoryItem.consumable) {
                Label("Consumable", icon: .consumable)
            }
        }
        
        /*
         Slows down the list scroll
         Menu {
            Picker(selection: $categoryItem.star, label: Text("Star")) {
                ForEach(StarColor.allCases, id: \.rawValue) {
                    Label($0.title, icon: .star)
                        .tag($0)
                        .foregroundColor($0.color)
                }
            }
        } label: {
            Label("Star...", icon: .star)
        }*/
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
