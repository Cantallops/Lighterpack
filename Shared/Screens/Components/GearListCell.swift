import SwiftUI

struct GearListCell: View {
    @EnvironmentObject var settingsStore: SettingsStore
    private var totalUnit: WeightUnit { settingsStore.totalUnit }
    private var currencySymbol: String { settingsStore.currencySymbol }
    private var showPrice: Bool { settingsStore.price }
    private var showListDesc: Bool { settingsStore.listDescription }

    var list: GearList
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(list.name)
                if showListDesc && !list.description.isEmpty {
                    Text(list.description)
                        .font(.footnote)
                        .lineLimit(1)
                        .foregroundColor(Color(.secondaryLabel))
                }
            }
            Spacer()
            HStack {
                VStack(alignment: .trailing) {
                    if showPrice {
                        Text(list.totalPrice.formattedPrice(currencySymbol))
                    }
                    Text(list.totalWeight.formattedWeight(totalUnit))
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
