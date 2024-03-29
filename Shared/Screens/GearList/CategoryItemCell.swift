import SwiftUI
import Entities
import DesignSystem
import Repository

struct CategoryItemCell: View {
    @EnvironmentObject var repository: Repository

    @Binding var categoryItem: CategoryItem
    var item: Item? { repository.get(itemWithId: categoryItem.itemId) }

    var body: some View {
        if let item = item {
            HStack {
                if let url = item.fullImageURL, repository.showImages {
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
                        if categoryItem.worn && repository.showWorn {
                            Icon(.worn)
                        }
                        if categoryItem.consumable && repository.showConsumable {
                            Icon(.consumable)
                        }
                    }.font(.caption)
                    Text(item.description)
                        .font(.footnote)
                        .lineLimit(2)
                        .foregroundColor(.secondaryLabel)
                }
                Spacer()
                HStack {
                    VStack(alignment: .trailing) {
                        if repository.showPrice {
                            Text(item.price.formattedPrice(repository.currencySymbol))
                        }
                        Text(item.formattedWeight)
                    }
                    .foregroundColor(.tertiaryLabel)
                    HStack(alignment: .lastTextBaseline, spacing: 0) {
                        Text(String("𝗑\(categoryItem.qty)"))
                            .font(.title3)
                    }
                }
            }
            .contextMenu(menuItems: { contextMenu })
        }
    }

    @ViewBuilder
    private var contextMenu: some View {
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
        Divider()
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
        }
    }
}

extension StarColor {
    var color: Color {
        switch self {
        case .none: return .label
        case .yellow: return .systemYellow
        case .red: return .systemRed
        case .green: return .systemGreen
        }
    }
}
/*
struct CategoryItemCell_Previews: PreviewProvider {
    static var previews: some View {
        CategoryItemCell()
    }
}*/
