import SwiftUI
import SunburstDiagram
import Combine
import Entities
import DesignSystem
import Repository

struct Pie: View {
    @ObservedObject var configuration: SunburstConfiguration
    var body: some View {
        SunburstView(configuration: configuration)
            .frame(minHeight: 260)
    }
}

private struct ListPieSectionView: View {

    @EnvironmentObject var repository: Repository
    @Environment(\.redactionReasons) private var redactedReasons

    @ObservedObject var configuration: SunburstConfiguration
    @Binding var viewMode: ViewMode
    var list: Entities.List
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
            totalText = total.formattedWeight(repository.totalUnit)
            wornText = worn.formattedWeight(repository.totalUnit)
            consumableText = consumable.formattedWeight(repository.totalUnit)
            baseText = base.formattedWeight(repository.totalUnit)
        case .price:
            totalText = total.formattedPrice(repository.currencySymbol)
            wornText = worn.formattedPrice(repository.currencySymbol)
            consumableText = consumable.formattedPrice(repository.currencySymbol)
            baseText = base.formattedPrice(repository.currencySymbol)
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
                            .foregroundColor(node.backgroundColor ?? Color(.secondarySystemFill))
                            .unredacted()
                        Text(node.name)
                        Spacer()
                        switch viewMode {
                        case .weight: Text((node.value ?? 0).formattedWeight(repository.totalUnit))
                        case .price: Text((node.value ?? 0).formattedPrice(repository.currencySymbol))
                        }
                    }
                }
                .buttonStyle(CategoryButtonStyle(selectedColor: selectionColor, selected: selectedId == node.id))
                .eraseToAnyView()

            }.disabled(!redactedReasons.isEmpty)
            DisclosureGroup {
                if repository.showWorn {
                    HStack {
                        Icon(.worn)
                        Text("Worn")
                        Spacer()
                        Text(wornText).redacted(reason: redactedReasons)
                    }
                }
                if repository.showConsumable {
                    HStack {
                        Icon(.consumable)
                        Text("Consumable")
                        Spacer()
                        Text(consumableText).redacted(reason: redactedReasons)
                    }
                }
                HStack {
                    Icon(.baseWeight)
                    Text("Base weight")
                    Spacer()
                    Text(baseText).redacted(reason: redactedReasons)
                }
            } label: {
                HStack {
                    Text("Total").fontWeight(.bold)
                    Spacer()
                    Text(totalText).redacted(reason: redactedReasons)
                }
            }.unredacted()
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
            if repository.showPrice {
                Picker("", selection: $viewMode) {
                    ForEach(ViewMode.allCases, id: \.rawValue) {
                        Text("\($0.name)").tag($0)
                    }
                }.pickerStyle(SegmentedPickerStyle())
                .unredacted()
            }
        }
        .listRowInsets(EdgeInsets())
        .textCase(.none)
        .padding(.bottom)
        .disabled(!redactedReasons.isEmpty)
    }
}

struct ListPieSection: View {
    @EnvironmentObject var repository: Repository
    
    var list: Entities.List

    @State private var disposable: AnyCancellable?
    @State private var viewMode: ListPieSectionView.ViewMode = .weight

    @StateObject private var conf: SunburstConfiguration = {
        let conf = SunburstConfiguration(nodes: [])
        conf.maximumExpandedRingsShownCount = 1
        conf.startingAngle = 90
        return conf
    }()

    var body: some View {
        ListPieSectionView(
            configuration: conf,
            viewMode: .init(get: {
                viewMode
            }, set: {
                viewMode = $0
                configure()
            }),
            list: list
        ).onFirstAppear {
            configure()
        }.onReceive(repository.objectWillChange.eraseToAnyPublisher()) { _ in
            configure()
        }
}

    func configure() {
        disposable = Just(list)
            .map(calculateNodes)
            //.receive(on: DispatchQueue.global(qos: .background))
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

    func calculateNodes(list: Entities.List) -> ([Node], Double) {
        let nodes: [Node] = list.pieNodes(
            repository: repository,
            calculateUsing: viewMode
        )
        let total = nodes.reduce(0.0, { $0 + $1.value! })
        return (nodes, total)
    }


}


private extension Entities.List {
    func pieNodes(
        repository: Repository,
        calculateUsing viewMode: ListPieSectionView.ViewMode
    ) -> [Node] {
        categoryIds.compactMap { repository.get(categoryWithId: $0) }.compactMap { category in
            var desc = "\(category.name): \(category.subtotalWeight.formattedWeight(repository.totalUnit))"
            var value: Double = Double(category.subtotalWeight)
            if repository.showPrice {
                desc = "\(desc) \(category.subtotalPrice.formattedPrice(repository.currencySymbol))"
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
                    repository: repository,
                    calculateUsing: viewMode
                )
            )
        }
    }
}

private extension Entities.Category {

    var pieId: String {
        "Cat\(id)"
    }

    func pieNodes(
        repository: Repository,
        calculateUsing viewMode: ListPieSectionView.ViewMode
    ) -> [Node] {
        categoryItems
            .sorted(by: {
                guard let item0 = repository.get(itemWithId: $0.itemId),
                      let item1 = repository.get(itemWithId: $1.itemId) else { return false }
                switch viewMode {
                case .weight: return item0.weight > item1.weight
                case .price: return item0.price > item1.price
                }
            })
            .enumerated()
            .map { (offset: Int, item) in
                let variation: CGFloat = (CGFloat(offset) / CGFloat(categoryItems.count))/2
                return item.pieNode(
                    repository: repository,
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
        repository: Repository,
        color: Color?,
        calculateUsing viewMode: ListPieSectionView.ViewMode
    ) -> Node {
        guard let item = repository.get(itemWithId: itemId) else { fatalError() }
        var desc = "\(item.name): \(weight.formattedWeight(item.authorUnit))"
        var value: Double = Double(weight)
        if repository.showPrice {
            desc = "\(desc) \(price.formattedPrice(repository.currencySymbol))"
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
