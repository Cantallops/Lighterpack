import SwiftUI

struct GearListCell: View {
    @AppSetting(.totalUnit) private var totalUnit: WeightUnit
    @AppSetting(.currencySymbol) private var currencySymbol: String
    @AppSetting(.showPrice) private var showPrice: Bool
    @AppSetting(.showListDescription) private var showListDesc: Bool

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

struct GearListCell_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            GearListCell(list: .placeholder)
            GearListCell(list: .placeholder)
                .redacted(reason: .placeholder)
            Group {
                GearListCell(list: .placeholder)
                GearListCell(list: .placeholder)
                    .redacted(reason: .placeholder)
            }
            .background(Color(.systemBackground))
            .environment(\.colorScheme, .dark)
        }
        .previewLayout(PreviewLayout.sizeThatFits)
    }
}
