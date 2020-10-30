import SwiftUI
import DesignSystem
import Repository
import Entities

struct ListCreateScreen: Screen {
    @EnvironmentObject var repository: Repository

    @State private var title: String = ""
    @State private var desc: String = ""
    @State private var createdList: Entities.List?
    @State private var status: Status = .idle

    enum Status {
        case idle
        case error([FormErrorEntry])

        var formErrors: [FormErrorEntry] {
            switch self {
            case .error(let errors):
                return errors
            default:
                return []
            }
        }
    }

    var content: some View {
        if let list = createdList {
            ListScreen(list: repository.binding(forList: list))
        } else {
            SwiftUI.List {
                Section(header: SectionHeader(title: "Title")) {
                    Field(
                        "Title",
                        text: $title,
                        error: status.formErrors.of(.name)?.message
                    )
                }
                if repository.showListDescription {
                    Section(header: SectionHeader(title: "Description")) {
                        TextEditor(text: $desc)
                            .frame(maxHeight: 300)
                    }
                }
                Section {
                    Button(action: {
                        guard !title.isEmpty else {
                            status = .error([
                                .init(field: .name, message: "Please enter a title")
                            ])
                            return
                        }
                        createdList = repository.create(
                            listWithName: title,
                            description: desc
                        )
                    }, label: {
                        HStack {
                            Spacer()
                            Text("Create")
                            Spacer()
                        }
                    })
                    .foregroundColor(.white)
                    .listRowBackgroundColor(.systemOrange)
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("New list")
        }
    }
}

private extension Repository {
    func create(
        listWithName name: String,
        description: String
    ) -> Entities.List {
        let list = Entities.List(
            id: .max,
            name: name,
            categoryIds: [],
            description: description,
            externalId: "",
            totalWeight: 0,
            totalWornWeight: 0,
            totalConsumableWeight: 0,
            totalBaseWeight: 0,
            totalPackWeight: 0,
            totalPrice: 0,
            totalConsumablePrice: 0,
            totalWornPrice: 0,
            totalQty: 0
        )
        return create(list: list)
    }
}
