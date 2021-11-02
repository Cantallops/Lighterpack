import SwiftUI
import Entities
import DesignSystem
import Repository

struct HomeScreen: Screen {
    
    @EnvironmentObject var repository: Repository
    @State private var isShowingSettings = false
    @SceneStorage("opened_list") var openedList: Int?
    @SceneStorage("opened_all_gear") var openedAllGear: Bool = false
    @State private var newList: Entities.List?

    var content: some View {
        if repository.isLoggedIn {
            NavigationView {
                List {
                    Section(
                        header: HStack {
                            Text("LighterPack")
                                .font(.system(.largeTitle, design: .rounded))
                                .bold()
                                .foregroundColor(.label)
                        }
                        .textCase(.none)
                        .removeListRowInsets()
                        .padding(.top)
                    ){

                    }.unredacted()

                    Section(header: SectionHeader(title: "Lists", detail: {
                        Menu(content: {
                            Button {
                                newList = repository.createList()
                            } label: {
                                Label("New list", icon: .add)
                            }
                            Button {
                                newList = repository.createList()
                            } label: {
                                Label("Import", icon: .import)
                            }
                        }) {
                            Icon(.add)
                        }
                        if let list = newList {
                            NavigationLink(
                                "",
                                destination: ListScreen(list: repository.binding(forList: list)),
                                isActive: .init(get: { newList != nil }, set: { _ in newList = nil })
                            )
                        }
                    }).unredacted()) {
                        ForEach(repository.getAllLists()) { list in
                            NavigationLink(
                                destination: ListScreen(list: repository.binding(forList: list)),
                                tag: list.id,
                                selection: $openedList
                            ) {
                                ListCell(list: list)
                                    .redacted(reason: repository.isPlaceholder ? .placeholder : [])
                            }.unredacted()
                        }.onDelete(perform: removeList)
                    }.disabled(repository.isPlaceholder)

                    Section {
                        NavigationLink(destination: ItemsListScreen(), isActive: $openedAllGear) {
                            Label("All gear", icon: .gearList)
                                .font(.system(.body, design: .rounded))
                        }.unredacted()
                    }.disabled(repository.isPlaceholder)

                    footer

                }
                .redacted(reason: repository.isPlaceholder ? .placeholder : [])
                .listStyle(InsetGroupedListStyle())
                .navigationBarTitle("Home")
                .navigationBarHidden(true)
            }
            .sheet(isPresented: $isShowingSettings) {
                NavigationView {
                    ProfileScreen()
                        .navigationBarItems(
                            trailing: Button(
                                action: { isShowingSettings = false },
                                label: {
                                    Icon(.close)
                                }))
                }
                .environmentObject(repository)
            }
        } else {
            NavigationView {
                LoginScreen()
            }
        }
    }
}

private extension HomeScreen {
    var header: some View {
        Section(header: HStack {
            Text("LighterPack")
                .font(.system(.title, design: .rounded))
                .bold()
            }
            .textCase(.none)
            .foregroundColor(.label)
            .removeListRowInsets()
        ) {}
    }
    var footer: some View {
        Group {
            Section {
                Button(action: showSettings, label: {
                    HStack {
                        Spacer()
                        HStack {
                            Icon(.accountSettings)
                            Text("Settings")
                        }
                        Spacer()
                    }
                })
                .foregroundColor(.secondaryLabel)
                .listRowBackgroundColor(.systemGroupedBackground)
            }

            Section {
                Group {
                    switch repository.syncStatus {
                    case .idle: EmptyView()
                    case .updating:
                        HStack {
                            Spacer()
                            ProgressView("Updating")
                            Spacer()
                        }
                    case .updated(let date):
                        Button(action: repository.forceSync) {
                            HStack {
                                Spacer()
                                VStack {
                                    Text("Last update ").bold() + Text(date, style: .relative)  + Text(" ago")
                                    Text("Sync now").foregroundColor(.accentColor)
                                }
                                Spacer()
                            }
                        }
                    case .error(let error, _):
                        Button(action: repository.forceSync) {
                            VStack {
                                HStack {
                                    Spacer()
                                    VStack {
                                        Text("Error").foregroundColor(.systemRed).bold()
                                        Text(error.localizedDescription)
                                    }
                                    Spacer()
                                }
                                Text("Try again").foregroundColor(.accentColor)
                            }
                        }
                    }
                }
                .font(.system(.footnote, design: .rounded))
                .multilineTextAlignment(.center)
                .foregroundColor(.secondaryLabel)
                .listRowBackgroundColor(.systemGroupedBackground)
            }
        }.unredacted()
    }

    func showSettings() {
        isShowingSettings = true
    }

    func removeList(at indices: IndexSet) {
        let lists = repository.getAllLists()
        indices.forEach { index in
            repository.remove(listWithId: lists[index].id)
        }
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
            .environmentObject({ () -> Repository in
                let repo = Repository()
                return repo
            }())
    }
}

private extension Repository {
    func createList() -> Entities.List {
        let list = Entities.List(
            id: .min,
            name: "",
            categoryIds: [],
            description: "",
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
