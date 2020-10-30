import SwiftUI
import Entities
import DesignSystem
import Repository

struct ItemScreen: Screen {
    @EnvironmentObject var repository: Repository

    private var numberFormatter: NumberFormatter {
        let numberFormatter = NumberFormatter()
        numberFormatter.allowsFloats = true
        numberFormatter.alwaysShowsDecimalSeparator = true
        numberFormatter.minimumFractionDigits = 2
        numberFormatter.maximumFractionDigits = 2
        return numberFormatter
    }

    @Binding var item: Item

    var content: some View {
        List {
            Section {
                if let url = item.fullImageURL, repository.showImages {
                    NetworkImage(url: url)
                        .aspectRatio(contentMode: .fit)
                        .removeListRowInsets()
                }
                Field("Title", text: $item.name)
                if repository.showPrice {
                    HStack {
                        Text("Price").bold()
                        Spacer()
                        DecimalField(amount: $item.price, formatter: numberFormatter)
                            .multilineTextAlignment(.trailing)
                        Text(repository.currencySymbol)
                            .frame(maxHeight: .infinity)
                            .padding(.horizontal)
                            .frame(width: 60)
                            .backgroundColor(Color.quaternarySystemFill.opacity(0.5))
                    }
                    .padding(.leading)
                    .removeListRowInsets()
                }
                HStack {
                    Text("Weight").bold()
                    Spacer()
                    DecimalField(
                        amount: .init(
                            get: { item.weight.convertedWeight(item.authorUnit) },
                            set: { newValue in
                                item.weight = newValue.rawWeight(item.authorUnit)
                            }
                        ),
                        formatter: numberFormatter
                    )
                    Menu {
                        Picker(selection: $item.authorUnit, label: Text("WeighhUnit")) {
                            ForEach(WeightUnit.allCases, id: \.rawValue) {
                                Text($0.rawValue).tag($0)
                            }
                        }
                    } label: {
                        Text(item.authorUnit.rawValue)
                            .padding(.horizontal)
                            .frame(width: 60)
                    }
                    .frame(maxHeight: .infinity)
                    .backgroundColor(Color.quaternarySystemFill.opacity(0.5))

                }
                .padding(.leading)
                .removeListRowInsets()
            }
            Section(header: SectionHeader(title: "Description")) {
                TextEditor(text: $item.description)
                    .frame(minHeight: 200)
            }

            Section(
                header: SectionHeader(title: "Link"),
                footer: Group {
                    LinkPreview(link: item.url)
                        .id(item.url)
                }
                .removeListRowInsets()
                .padding(.top)
            ) {
                Field("ex) https://lighterpack.com", text: $item.url, icon: .link)
                    .keyboardType(.URL)
                    .autocapitalization(.none)
            }

        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(item.name)
    }
}

/*struct ItemScreen_Previews: PreviewProvider {
    static var previews: some View {
        ItemScreen(item: .init(id: 0, name: "", description: "", weight: 0, authorUnit: .g, price: 1, image: "", imageUrl: "", url: ""))
    }
}*/
