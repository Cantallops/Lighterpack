import Entities
import SwiftUI
import DesignSystem

struct ItemCell: View {
    let item: Item
    let currencySymbol: String
    let showPrice: Bool
    let showImages: Bool

    init(
        item: Item,
        currencySymbol: String = "$",
        showPrice: Bool = true,
        showImages: Bool = true
    ) {
        self.item = item
        self.currencySymbol = currencySymbol
        self.showPrice = showPrice
        self.showImages = showImages
    }

    var body: some View {
        HStack {
            if let url = item.fullImageURL, showImages {
                NetworkImage(url: url)
                    .frame(width: 60, height: 60)
                    .cornerRadius(4)
            }
            VStack(alignment: .leading) {
                HStack {
                    Text(item.name)
                    if !item.url.isEmpty && URL(string: item.url) != nil {
                        Icon(.link)
                            .font(.system(.footnote))
                    }
                }
                Text(item.description)
                    .font(.footnote)
                    .lineLimit(2)
                    .foregroundColor(.secondaryLabel)
            }
            Spacer()
            HStack {
                VStack(alignment: .trailing) {
                    if showPrice {
                        Text(item.price.formattedPrice(currencySymbol))
                    }
                    Text(item.formattedWeight)
                }
            }
        }
    }
}

struct ItemCell_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ItemCell(item: .placeholder)
            ItemCell(item: .placeholder)
                .redacted(reason: .placeholder)
            Group {
                ItemCell(item: .placeholder)
                ItemCell(item: .placeholder)
                    .redacted(reason: .placeholder)
            }
            .backgroundColor(.systemBackground)
            .environment(\.colorScheme, .dark)
        }
        .previewLayout(PreviewLayout.sizeThatFits)
    }
}
