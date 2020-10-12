import SwiftUI

struct ItemScreen: View {
    @EnvironmentObject var settingsStore: SettingsStore
    @EnvironmentObject var libraryStore: LibraryStore
    private var currencySymbol: String { settingsStore.currencySymbol }
    private var showPrice: Bool { settingsStore.price }
    private var showImages: Bool { settingsStore.images }
    private var numberFormatter: NumberFormatter {
        let numberFormatter = NumberFormatter()
        numberFormatter.allowsFloats = true
        numberFormatter.alwaysShowsDecimalSeparator = true
        numberFormatter.minimumFractionDigits = 2
        numberFormatter.maximumFractionDigits = 2
        return numberFormatter
    }

    var item: Item

    @State private var modifableItem: Item = .placeholder
    @State private var x: Bool = false

    var body: some View {
        Form {
            Section {
                if let url = modifableItem.fullImageURL, showImages {
                    NetworkImage(url: url)
                        .aspectRatio(contentMode: .fit)
                        .listRowInsets(EdgeInsets())
                }
                Field("Title", text: $modifableItem.name)
                if showPrice {
                    HStack {
                        Text("Price").bold()
                        Spacer()
                        DecimalField(amount: $modifableItem.price, formatter: numberFormatter)
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
                            get: { modifableItem.weight.convertedWeight(modifableItem.authorUnit)
                            },
                            set: { newValue in
                                modifableItem.weight = newValue.rawWeight(modifableItem.authorUnit)
                            }
                        ),
                        formatter: numberFormatter
                    )
                    Menu {
                        Picker(selection: $modifableItem.authorUnit, label: Text("WeighhUnit")) {
                            ForEach(WeightUnit.allCases, id: \.rawValue) {
                                Text($0.rawValue).tag($0)
                            }
                        }
                    } label: {
                        Text(modifableItem.authorUnit.rawValue)
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
                TextEditor(text: $modifableItem.description)
            }
        }
        .navigationTitle(modifableItem.name)
        .onAppear {
            if modifableItem.isPlaceholder {
                modifableItem = item
            }
        }.onChange(of: modifableItem) { item in
            libraryStore.replace(item: item)
        }
    }
}

struct ItemScreen_Previews: PreviewProvider {
    static var previews: some View {
        ItemScreen(item: .init(id: 0, name: "", description: "", weight: 0, authorUnit: .g, price: 1, image: "", imageUrl: "", url: ""))
    }
}
