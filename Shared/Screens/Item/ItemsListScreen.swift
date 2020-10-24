import SwiftUI

struct ItemsListScreen: View {
    @EnvironmentObject var libraryStore: LibraryStore
    @AppSetting(.showPrice) private var showPrice: Bool

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

    private func filters(lhs: Item, rhs: Item) -> Bool {
        switch order {
        case .asc:
            switch sort {
            case .default: return false
            case .weight: return lhs.weight < rhs.weight
            case .price: return lhs.price < rhs.price
            case .name: return lhs.name > rhs.name
            }
        case .desc:
            switch sort {
            case .default: return false
            case .weight: return lhs.weight > rhs.weight
            case .price: return lhs.price > rhs.price
            case .name: return lhs.name < rhs.name
            }
        }
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
            ForEach(libraryStore.items.sorted(by: filters)) { (item: Item) in
                NavigationLink(destination: ItemScreen(item: libraryStore.binding(forItem: item))) {
                    ItemCell(item: item)
                }
            }.animation(.default)
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Gear")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Menu {
                    Picker(selection: $sort.animation(), label: Text("Sorting options")) {
                        ForEach(Sort.allCases.filter({
                            if showPrice { return true }
                            return $0 != .price
                        }), id: \.rawValue) {
                            Label($0.rawValue, icon: $0.icon).tag($0)
                        }
                    }

                    Picker(selection: $order.animation(), label: Text("Order options")) {
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
