import Entities
import SwiftUI
import DesignSystem
import Repository

struct ItemsListScreen: Screen {
    @EnvironmentObject var repository: Repository

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

    var content: some View {
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
            ForEach(repository.getAllItems().sorted(by: filters)) { (item: Item) in
                NavigationLink(destination: ItemScreen(item: repository.binding(forItem: item))) {
                    ItemCell(
                        item: item,
                        currencySymbol: repository.currencySymbol,
                        showPrice: repository.showPrice,
                        showImages: repository.showImages
                    )
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Gear")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Menu {
                    Picker(selection: $sort.animation(), label: Text("Sorting options")) {
                        ForEach(Sort.allCases.filter({
                            if repository.showPrice { return true }
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
        }
    }
}

struct ItemsListScreen_Previews: PreviewProvider {
    static var previews: some View {
        ItemsListScreen()
    }
}
