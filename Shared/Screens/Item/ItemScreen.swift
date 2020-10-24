import SwiftUI

struct ItemScreen: View {
    @EnvironmentObject var settingsStore: SettingsStore
    @EnvironmentObject var libraryStore: LibraryStore
    @AppSetting(.currencySymbol) private var currencySymbol: String
    @AppSetting(.showPrice) private var showPrice: Bool
    @AppSetting(.showImages) private var showImages: Bool
    private var numberFormatter: NumberFormatter {
        let numberFormatter = NumberFormatter()
        numberFormatter.allowsFloats = true
        numberFormatter.alwaysShowsDecimalSeparator = true
        numberFormatter.minimumFractionDigits = 2
        numberFormatter.maximumFractionDigits = 2
        return numberFormatter
    }

    @Binding var item: Item

    var body: some View {
        Form {
            Section {
                if let url = item.fullImageURL, showImages {
                    NetworkImage(url: url)
                        .aspectRatio(contentMode: .fit)
                        .listRowInsets(EdgeInsets())
                }
                Field("Title", text: $item.name)
                if showPrice {
                    HStack {
                        Text("Price").bold()
                        Spacer()
                        DecimalField(amount: $item.price, formatter: numberFormatter)
                            .multilineTextAlignment(.trailing)
                        Text(currencySymbol)
                            .frame(maxHeight: .infinity)
                            .padding(.horizontal)
                            .frame(width: 60)
                            .background(Color(.quaternarySystemFill).opacity(0.5))
                    }
                    .padding(.leading)
                    .listRowInsets(.init())
                }
                HStack {
                    Text("Weight").bold()
                    Spacer()
                    DecimalField(
                        amount: .init(
                            get: { item.weight.convertedWeight(item.authorUnit)
                            },
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
                    .background(Color(.quaternarySystemFill).opacity(0.5))

                }
                .padding(.leading)
                .listRowInsets(.init())
            }
            Section(header: SectionHeader(title: "Description")) {
                TextEditor(text: $item.description)
            }
        }
        .navigationTitle(item.name)
    }
}

/*struct ItemScreen_Previews: PreviewProvider {
    static var previews: some View {
        ItemScreen(item: .init(id: 0, name: "", description: "", weight: 0, authorUnit: .g, price: 1, image: "", imageUrl: "", url: ""))
    }
}*/
