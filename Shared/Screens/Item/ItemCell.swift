import SwiftUI

struct ItemCell: View {
    @AppSetting(.currencySymbol) private var currencySymbol: String
    @AppSetting(.showPrice) private var showPrice: Bool
    @AppSetting(.showImages) private var showImages: Bool

    var item: Item
    var body: some View {
        HStack {
            if let url = item.fullImageURL, showImages {
                NetworkImage(url: url)
                    .frame(width: 60, height: 60)
                    .cornerRadius(4)
            }
            VStack(alignment: .leading) {
                Text(item.name)
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
            .background(Color(.systemBackground))
            .environment(\.colorScheme, .dark)
        }
        .previewLayout(PreviewLayout.sizeThatFits)
    }
}
