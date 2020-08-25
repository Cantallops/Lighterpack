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
    @AppStorage(SettingKey.totalUnit.rawValue) var totalUnit: WeigthUnit = .oz
    @AppStorage(SettingKey.optionalFieldWorn.rawValue) var showWorn: Bool = true
    @AppStorage(SettingKey.optionalFieldPrice.rawValue) var showPrice: Bool = true
    @AppStorage(SettingKey.optionalFieldConsumable.rawValue) var showConsumable: Bool = true
    @AppStorage(SettingKey.currencySymbol.rawValue) var currencySymbol: String = "$"

    @ObservedObject var configuration: SunburstConfiguration
    @Binding var viewMode: ViewMode

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
        let (total, worn, consumable) = configuration.nodes.reduce((0.0, 0.0, 0.0)) { (result, node) in
            guard let category = (node.relatedObject?.wrappedValue as? DBCategory) else {
                return result
            }
            var wornValue: Double = 0
            var consumableValue: Double = 0
            switch viewMode {
            case .weight:
                wornValue = Double(category.wornWeight)
                consumableValue = Double(category.consumbleWeight)
            case .price:
                wornValue = Double(category.wornPrice)
                consumableValue = Double(category.consumblePrice)
            }

            return (
                result.0 + (node.value ?? 0),
                showWorn ? (result.1 + wornValue) : 0,
                showConsumable ? (result.2 + consumableValue) : 0
             )
        }
        let base = total - consumable
        var totalText = ""
        var wornText = ""
        var consumableText = ""
        var baseText = ""
        switch viewMode {
        case .weight:
            totalText = base.formattedWeight(totalUnit)
            wornText = worn.formattedWeight(totalUnit)
            consumableText = consumable.formattedWeight(totalUnit)
            baseText = base.formattedWeight(totalUnit)
        case .price:
            totalText = total.formattedPrice(currencySymbol)
            wornText = worn.formattedPrice(currencySymbol)
            consumableText = consumable.formattedPrice(currencySymbol)
            baseText = base.formattedPrice(currencySymbol)
        }
        return Section(header: header) {
            ForEach(configuration.nodes) { (node: Node) -> AnyView in
                let category = node.relatedObject!.wrappedValue as! DBCategory
                return Button {
                    configuration.selectedNode = node
                    configuration.focusedNode = node
                } label: {
                    HStack {
                        Icon(.categoryDot)
                            .foregroundColor(node.backgroundColor ?? .clear)
                        Text(category.name)
                        Spacer()
                        switch viewMode {
                        case .weight: Text((node.value ?? 0).formattedWeight(totalUnit))
                        case .price: Text((node.value ?? 0).formattedPrice(currencySymbol))
                        }

                    }
                }
                .foregroundColor(Color(.label))
                .listRowBackground(configuration.selectedNode?.id == node.id ? node.backgroundColor?.opacity(0.3) : Color(.tertiarySystemBackground))
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

                if let selected = configuration.selectedNode {
                    Text(selected.name)
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

    @AppStorage(SettingKey.totalUnit.rawValue) var totalUnit: WeigthUnit = .oz
    @AppStorage(SettingKey.optionalFieldPrice.rawValue) var showPrice: Bool = true
    @AppStorage(SettingKey.currencySymbol.rawValue) var currencySymbol: String = "$"
    @ObservedObject var list: DBList

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
        }))
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

    func calculateNodes(list: DBList) -> ([Node], Double) {
        let nodes: [Node] = list.pieNodes(currencySymbol: currencySymbol, totalUnit: totalUnit, showPrice: showPrice, calculateUsing: viewMode)
        let total = nodes.reduce(0.0, { $0 + $1.value! })
        return (nodes, total)
    }


}


private extension DBList {

    func pieNodes(
        currencySymbol: String,
        totalUnit: WeigthUnit,
        showPrice: Bool,
        calculateUsing viewMode: GearListPieSectionView.ViewMode
    ) -> [Node] {
        categoriesArray.map { (category: DBCategory) in
            var name = "\(category.name): \(category.weight.formattedWeight(totalUnit))"
            var value: Double = Double(category.weight)
            if showPrice {
                name = "\(name) \(category.price.formattedPrice(currencySymbol))"
                if viewMode == .price {
                    value = Double(category.price)
                }
            }
            return Node(
                id: "Cat\(category.id)",
                name: name,
                showName: false,
                value: value,
                relatedObject: AnyObjectEquatable(category),
                backgroundColor: Color(hex: category.hexColor),
                children: category.pieNodes(
                    currencySymbol: currencySymbol,
                    totalUnit: totalUnit,
                    showPrice: showPrice,
                    calculateUsing: viewMode
                )
            )
        }
    }
}

private extension DBCategory {
    func pieNodes(
        currencySymbol: String,
        totalUnit: WeigthUnit,
        showPrice: Bool,
        calculateUsing viewMode: GearListPieSectionView.ViewMode
    ) -> [Node] {
        itemsArray
            .sorted(by: {
                switch viewMode {
                case .weight: return $0.weight > $1.weight
                case .price: return $0.price > $1.price
                }
            })
            .enumerated()
            .map { (offset: Int, item: DBCategoryItem) in
                var name = "\(item.item.name): \(item.formattedWeight)"
                var value: Double = Double(item.weight)
                if showPrice {
                    name = "\(name) \(item.price.formattedPrice(currencySymbol))"
                    if viewMode == .price {
                        value = Double(item.price)
                    }
                }
                let variation: CGFloat = (CGFloat(offset) / CGFloat(items.count))/2
                return Node(
                    id: "Item\(item.item.id)",
                    name: name,
                    showName: false,
                    isFocusable: false,
                    value: value,
                    relatedObject: AnyObjectEquatable(item),
                    backgroundColor: Color(hex: hexColor)?
                        .variant(by: variation)
                )
            }
    }
}
