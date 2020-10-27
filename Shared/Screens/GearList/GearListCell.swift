import SwiftUI
import Entities
import Repository

struct GearListCell: View {

    @EnvironmentObject var repository: Repository

    var list: Entities.List
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(list.name)
                    .font(.system(.body, design: .rounded))
                if repository.showListDescription && !list.description.isEmpty {
                    Text(list.description)
                        .font(.system(.footnote, design: .rounded))
                        .lineLimit(1)
                        .foregroundColor(Color(.secondaryLabel))
                }
            }
            Spacer()
            HStack {
                VStack(alignment: .trailing) {
                    Text(list.totalWeight.formattedWeight(repository.totalUnit))
                        .font(.system(.body, design: .rounded))

                    if repository.showPrice {
                        Text(list.totalPrice.formattedPrice(repository.currencySymbol))
                            .font(.system(.body, design: .rounded))
                            .foregroundColor(Color(.secondaryLabel))
                    }
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
