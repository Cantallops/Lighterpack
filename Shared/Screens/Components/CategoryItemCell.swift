import SwiftUI

struct CategoryItemCell: View {
    @EnvironmentObject var libraryStore: LibraryStore
    @EnvironmentObject var settingsStore: SettingsStore
    private var totalUnit: WeigthUnit { settingsStore.totalUnit }
    private var currencySymbol: String { settingsStore.currencySymbol }
    private var showWorn: Bool { settingsStore.worn }
    private var showPrice: Bool { settingsStore.price }
    private var showImages: Bool { settingsStore.images }
    private var showConsumable: Bool { settingsStore.consumable }

    var categoryItem: CategoryItem
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
        }
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
