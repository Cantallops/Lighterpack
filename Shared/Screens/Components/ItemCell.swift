import SwiftUI

struct ItemCell: View {
    @EnvironmentObject var settingsStore: SettingsStore
    private var currencySymbol: String { settingsStore.currencySymbol }
    private var showPrice: Bool { settingsStore.price }
    private var showImages: Bool { settingsStore.images }

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

