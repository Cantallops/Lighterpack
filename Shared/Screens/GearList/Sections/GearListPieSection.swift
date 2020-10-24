import SwiftUI
import SunburstDiagram
import Combine

struct Pie: View {
    @ObservedObject var configuration: SunburstConfiguration
    var body: some View {
        SunburstView(configuration: configuration)
            .frame(minHeight: 260)
    }
}

private struct GearListPieSectionView: View {

    @EnvironmentObject var libraryStore: LibraryStore

    @AppSetting(.totalUnit) private var totalUnit: WeightUnit
    @AppSetting(.showWorn) private var showWorn: Bool
    @AppSetting(.showPrice) private var showPrice: Bool
    @AppSetting(.showConsumable) private var showConsumable: Bool
    @AppSetting(.currencySymbol) private var currencySymbol: String

    @ObservedObject var configuration: SunburstConfiguration
    @Binding var viewMode: ViewMode
    var list: GearList
    enum ViewMode: Int, CaseIterable {
        case weight
        case price

        var name: String {
            switch self {
            case .weight:
                return "Weight"
            case .price:
                return "Price"
            }
        }
    }

    var body: some View {
        let (total, worn, consumable) = viewMode == .weight ?
            (list.totalWeight, list.totalWornWeight, list.totalConsumableWeight) :
            (list.totalPrice, list.totalWornPrice, list.totalConsumablePrice)

        let base = total - consumable
        var totalText = ""
        var wornText = ""
        var consumableText = ""
        var baseText = ""
        switch viewMode {
        case .weight:
            totalText = total.formattedWeight(totalUnit)
            wornText = worn.formattedWeight(totalUnit)
            consumableText = consumable.formattedWeight(totalUnit)
            baseText = base.formattedWeight(totalUnit)
        case .price:
            totalText = total.formattedPrice(currencySymbol)
            wornText = worn.formattedPrice(currencySymbol)
            consumableText = consumable.formattedPrice(currencySymbol)
            baseText = base.formattedPrice(currencySymbol)
        }
        let selectedId: AnyHashable = configuration.selectedNode?.id
        return Section(header: header) {
            ForEach(configuration.nodes) { (node: Node) -> AnyView in
                let selectionColor = node.backgroundColor?.opacity(0.3)
                return Button {
                    configuration.selectedNode = node
                    configuration.focusedNode = node
                } label: {
                    HStack {
                        Icon(.categoryDot)
                            .foregroundColor(node.backgroundColor ?? .clear)
                        Text(node.name)
                        Spacer()
                        switch viewMode {
                        case .weight: Text((node.value ?? 0).formattedWeight(totalUnit))
                        case .price: Text((node.value ?? 0).formattedPrice(currencySymbol))
                        }
                    }
                }
                .buttonStyle(CategoryButtonStyle(selectedColor: selectionColor, selected: selectedId == node.id))
                .eraseToAnyView()

            }
            DisclosureGroup {
                if showWorn {
                    HStack {
                        Icon(.worn)
                        Text("Worn")
                        Spacer()
                        Text(wornText)
                    }
                }
                if showConsumable {
                    HStack {
                        Icon(.consumable)
                        Text("Consumable")
                        Spacer()
                        Text(consumableText)
                    }
                }
                HStack {
                    Icon(.baseWeight)
                    Text("Base weight")
                    Spacer()
                    Text(baseText)
                }
            } label: {
                HStack {
                    Text("Total").fontWeight(.bold)
                    Spacer()
                    Text(totalText)
                }
            }
        }.onChange(of: showPrice) { showPrice in
            if !showPrice && viewMode == .price { viewMode = .weight }
        }

    }

    private var header: some View {
        VStack {
            ZStack(alignment: .bottomTrailing) {
                Pie(configuration: configuration)
                    .padding(.bottom)
                    .textCase(.none)
                    .foregroundColor(.init(.label))
                    .listRowInsets(EdgeInsets())

                if let selected = configuration.selectedNode, let name = selected.desc {
                    Text(name)
                        .padding(4)
                        .foregroundColor(Color(.label))
                        .background(Color(.systemGray4))
                        .cornerRadius(4)
                        .eraseToAnyView()
                }
            }
            if showPrice {
                Picker("", selection: $viewMode) {
                    ForEach(ViewMode.allCases, id: \.rawValue) {
                        Text("\($0.name)").tag($0)
                    }
                }.pickerStyle(SegmentedPickerStyle())
            }
        }
        .listRowInsets(EdgeInsets())
        .textCase(.none)
        .padding(.bottom)
    }
}

struct GearListPieSection: View {
    @EnvironmentObject var libraryStore: LibraryStore

    @AppSetting(.totalUnit) private var totalUnit: WeightUnit
    @AppSetting(.showPrice) private var showPrice: Bool
    @AppSetting(.currencySymbol) private var currencySymbol: String
    
    var list: GearList

    @State private var disposable: AnyCancellable?
    @State private var viewMode: GearListPieSectionView.ViewMode = .weight

    @StateObject private var conf: SunburstConfiguration = {
        let conf = SunburstConfiguration(nodes: [])
        conf.maximumExpandedRingsShownCount = 1
        conf.startingAngle = 90
        return conf
    }()

    var body: some View {
        GearListPieSectionView(configuration: conf, viewMode: .init(get: {
            viewMode
        }, set: {
            viewMode = $0
            configure()
        }), list: list)
            .onAppear {
                configure()
            }
    }

    func configure() {
        disposable = Just(list)
            .receive(on: DispatchQueue.global(qos: .userInteractive))
            .map(calculateNodes)
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { (nodes, total) in
                let selectedId = conf.selectedNode?.id as? String
                let focusedId = conf.focusedNode?.id as? String
                reselect(selectedId: selectedId, focusedId: focusedId, nodes: nodes)
                conf.nodes = nodes
                conf.calculationMode = .parentDependent(totalValue: total)
            })
    }

    func reselect(selectedId: String?, focusedId: String?, nodes: [Node]) {
        if let selectedId = selectedId {
            conf.selectedNode = getNode(nodes, withId: selectedId)
        }
        if let focusedId = focusedId {
            conf.focusedNode = getNode(nodes, withId: focusedId)
        }
    }

    func getNode(_ nodes: [Node], withId id: String) -> Node? {
        let anyId = AnyHashable(id)
        if id.starts(with: "Cat") {
            return nodes.first { anyId == $0.id }
        } else if id.starts(with: "Item") {
            return nodes.flatMap { $0.children }.first { anyId == $0.id }
        }
        return nil
    }

    func calculateNodes(list: GearList) -> ([Node], Double) {
        let nodes: [Node] = list.pieNodes(
            libraryStore: libraryStore,
            showPrice: showPrice,
            currencySymbol: currencySymbol,
            totalUnit: totalUnit,
            calculateUsing: viewMode
        )
        let total = nodes.reduce(0.0, { $0 + $1.value! })
        return (nodes, total)
    }


}


private extension GearList {
    func pieNodes(
        libraryStore: LibraryStore,
        showPrice: Bool,
        currencySymbol: String,
        totalUnit: WeightUnit,
        calculateUsing viewMode: GearListPieSectionView.ViewMode
    ) -> [Node] {
        libraryStore.categories(ofList: self).map { (category: Category) in
            var desc = "\(category.name): \(category.subtotalWeight.formattedWeight(totalUnit))"
            var value: Double = Double(category.subtotalWeight)
            if showPrice {
                desc = "\(desc) \(category.subtotalPrice.formattedPrice(currencySymbol))"
                if viewMode == .price {
                    value = Double(category.subtotalPrice)
                }
            }
            return Node(
                id: category.id,
                name: category.name,
                desc: desc,
                showName: false,
                value: value,
                backgroundColor: Color(category.color),
                children: category.pieNodes(
                    libraryStore: libraryStore,
                    showPrice: showPrice,
                    currencySymbol: currencySymbol,
                    calculateUsing: viewMode
                )
            )
        }
    }
}

private extension Category {

    var pieId: String {
        "Cat\(id)"
    }

    func pieNodes(
        libraryStore: LibraryStore,
        showPrice: Bool,
        currencySymbol: String,
        calculateUsing viewMode: GearListPieSectionView.ViewMode
    ) -> [Node] {
        categoryItems
            .sorted(by: {
                guard let item0 = libraryStore.item(withId: $0.itemId),
                      let item1 = libraryStore.item(withId: $1.itemId) else { return false }
                switch viewMode {
                case .weight: return item0.weight > item1.weight
                case .price: return item0.price > item1.price
                }
            })
            .enumerated()
            .map { (offset: Int, item) in
                let variation: CGFloat = (CGFloat(offset) / CGFloat(categoryItems.count))/2
                return item.pieNode(
                    libraryStore: libraryStore,
                    showPrice: showPrice,
                    currencySymbol: currencySymbol,
                    color: Color(color)?.variant(by: variation),
                    calculateUsing: viewMode
                )
            }
    }
}

private extension CategoryItem {
    var pieId: String {
        "Item\(itemId)"
    }
    func pieNode(
        libraryStore: LibraryStore,
        showPrice: Bool,
        currencySymbol: String,
        color: Color?,
        calculateUsing viewMode: GearListPieSectionView.ViewMode
    ) -> Node {
        guard let item = libraryStore.item(withId: itemId) else { fatalError() }
        var desc = "\(item.name): \(weight.formattedWeight(item.authorUnit))"
        var value: Double = Double(weight)
        if showPrice {
            desc = "\(desc) \(price.formattedPrice(currencySymbol))"
            if viewMode == .price {
                value = Double(price)
            }
        }
        return Node(
            id: itemId,
            name: item.name,
            desc: desc,
            showName: false,
            isFocusable: false,
            value: value,
            backgroundColor: color
        )
    }
}

struct CategoryButtonStyle: ButtonStyle {

    let selectedColor: Color?
    let selected: Bool

    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(Color(.label))
            .listRowBackground(configuration.isPressed || selected ? selectedColor : Color(.secondarySystemGroupedBackground))
    }

}
