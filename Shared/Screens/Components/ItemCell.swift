import SwiftUI

struct ItemCell: View {
    @AppStorage(SettingKey.currencySymbol.rawValue) var currencySymbol: String = ""
    @AppStorage(SettingKey.optionalFieldPrice.rawValue) var showPrice: Bool = true
    @AppStorage(SettingKey.optionalFieldImages.rawValue) var showImages: Bool = true

    var item: DBItem
    var body: some View {
        HStack {
            if let url = item.fullImageURL, showImages {
                NetworkImage(url: url)
                    .frame(width: 60, height: 60)
                    .cornerRadius(4)
            }
            VStack(alignment: .leading) {
                Text(item.name)
                Text(item.desc)
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

