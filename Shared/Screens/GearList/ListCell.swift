import SwiftUI
import Entities
import Repository

struct ListCell: View {

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
                        .foregroundColor(.secondaryLabel)
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
                            .foregroundColor(.secondaryLabel)
                    }
                }
            }
        }
    }
}

struct ListCell_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ListCell(list: .placeholder)
            ListCell(list: .placeholder)
                .redacted(reason: .placeholder)
            Group {
                ListCell(list: .placeholder)
                ListCell(list: .placeholder)
                    .redacted(reason: .placeholder)
            }
            .background(Color.systemBackground)
            .environment(\.colorScheme, .dark)
        }
        .previewLayout(PreviewLayout.sizeThatFits)
    }
}
