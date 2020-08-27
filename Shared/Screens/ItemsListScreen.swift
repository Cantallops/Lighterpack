import SwiftUI

struct ItemsListScreen: View {
    @EnvironmentObject var libraryStore: LibraryStore
    @EnvironmentObject var settingsStore: SettingsStore
    private var showPrice: Bool { settingsStore.price }

    @State private var sort: Sort = .default
    @State private var order: Order = .desc

    enum Sort: String, CaseIterable {
        case `default` = "Default"
        case name = "Name"
        case weight = "Weight"
        case price = "Price"


        var icon: Icon.Token {
            switch self {
            case .default: return Icon.Token.Sort.default
            case .weight: return Icon.Token.Sort.weight
            case .price: return Icon.Token.Sort.price
            case .name: return Icon.Token.Sort.name
            }
        }
    }

    enum Order: String, CaseIterable {
        case asc = "Ascending"
        case desc = "Descending"

        var icon: Icon.Token {
            switch self {
            case .asc: return Icon.Token.Sort.asc
            case .desc: return Icon.Token.Sort.desc
            }
        }
    }

    private var filteredItems: [Item] {
        libraryStore.items.sorted(by: {
            switch order {
            case .asc:
                switch sort {
                case .default: return false
                case .weight: return $0.weight < $1.weight
                case .price: return $0.price < $1.price
                case .name: return $0.name > $1.name
                }
            case .desc:
                switch sort {
                case .default: return false
                case .weight: return $0.weight > $1.weight
                case .price: return $0.price > $1.price
                case .name: return $0.name < $1.name
                }
            }
        })
    }

    var body: some View {
        List {
            Section {
                Button {

                } label: {
                    HStack {
                        Icon(.add)
                        Text("New gear")
                    }
                }
            }
            ForEach(filteredItems) { (item: Item) in
                ItemCell(item: item)
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Gear")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Menu {
                    Picker(selection: $sort, label: Text("Sorting options")) {
                        ForEach(Sort.allCases.filter({
                            if showPrice { return true }
                            return $0 != .price
                        }), id: \.rawValue) {
                            Label($0.rawValue, icon: $0.icon).tag($0)
                        }
                    }

                    Picker(selection: $order, label: Text("Order options")) {
                        ForEach(Order.allCases, id: \.rawValue) {
                            Label($0.rawValue, icon: $0.icon).tag($0)
                        }
                    }
                }
                label: {
                    Label("Sort", icon: .sort)
                }
            }
        }.onChange(of: showPrice) { show in
            guard !show else { return }
            if sort == .price { sort = .default }
        }
    }
}

struct ItemsListScreen_Previews: PreviewProvider {
    static var previews: some View {
        ItemsListScreen()
    }
}
