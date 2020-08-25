import SwiftUI

struct CategoryItemCell: View {
    @AppStorage(SettingKey.totalUnit.rawValue) var totalUnit: WeigthUnit = .oz
    @AppStorage(SettingKey.currencySymbol.rawValue) var currencySymbol: String = ""
    @AppStorage(SettingKey.optionalFieldWorn.rawValue) var showWorn: Bool = true
    @AppStorage(SettingKey.optionalFieldPrice.rawValue) var showPrice: Bool = true
    @AppStorage(SettingKey.optionalFieldImages.rawValue) var showImages: Bool = true
    @AppStorage(SettingKey.optionalFieldConsumable.rawValue) var showConsumable: Bool = true

    var categoryItem: DBCategoryItem
    var body: some View {
        HStack {
            if let url = categoryItem.item.fullImageURL, showImages {
                NetworkImage(url: url)
                    .frame(width: 60, height: 60)
                    .cornerRadius(4)
            }
            VStack(alignment: .leading) {
                Text(categoryItem.item.name)
                HStack {
                    if let star = StarColor(rawValue: Int(categoryItem.star)), star != .none {
                        Icon(.star)
                            .foregroundColor(star.color)
                    }
                    if !categoryItem.item.url.isEmpty {
                        Icon(.link)
                    }
                    if categoryItem.worn && showWorn {
                        Icon(.worn)
                    }
                    if categoryItem.consumable && showConsumable {
                        Icon(.consumable)
                    }
                }.font(.caption)
                Text(categoryItem.item.desc)
                    .font(.footnote)
                    .lineLimit(2)
                    .foregroundColor(Color(.secondaryLabel))
            }
            Spacer()
            HStack {
                VStack(alignment: .trailing) {
                    if showPrice {
                        Text(categoryItem.item.price.formattedPrice(currencySymbol))
                    }
                    Text(categoryItem.item.formattedWeight)
                }
                .foregroundColor(Color(.tertiaryLabel))
                HStack(alignment: .lastTextBaseline, spacing: 0) {
                    Icon(.quantity)
                        .font(.caption)
                    Text(String(categoryItem.quantity))
                        .font(.title3)
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
