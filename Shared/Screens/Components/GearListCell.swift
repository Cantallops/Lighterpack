import SwiftUI

struct GearListCell: View {
    @AppStorage(SettingKey.totalUnit.rawValue) var totalUnit: WeigthUnit = .oz
    @AppStorage(SettingKey.currencySymbol.rawValue) var currencySymbol: String = ""
    @AppStorage(SettingKey.optionalFieldPrice.rawValue) var showPrice: Bool = true
    @AppStorage(SettingKey.optionalFieldListDescription.rawValue) var showListDesc: Bool = true

    var list: DBList
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(list.name)
                if showListDesc && !list.desc.isEmpty {
                    Text(list.desc)
                        .font(.footnote)
                        .lineLimit(1)
                        .foregroundColor(Color(.secondaryLabel))
                }
            }
            Spacer()
            HStack {
                VStack(alignment: .trailing) {
                    if showPrice {
                        Text(list.price.formattedPrice(currencySymbol))
                    }
                    Text(list.weight.formattedWeight(totalUnit))
                }
            }
        }
    }
}
/*
struct GearListCell_Previews: PreviewProvider {
    static var previews: some View {
        GearListCell()
    }
}*/
