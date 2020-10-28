import SwiftUI
import Entities
import DesignSystem
import Repository

struct HomeScreen: View {
    
    @EnvironmentObject var repository: Repository
    @Namespace private var animation
    @State private var isShowingSettings = false
    @State private var newList = false

    var body: some View {
        if repository.isLoggedIn {
            NavigationView {
                List {
                    Section(
                        header: HStack {
                            Text("LighterPack")
                                .font(.system(.largeTitle, design: .rounded))
                                .bold()
                                .foregroundColor(Color(.label))
                        }
                        .textCase(.none)
                        .listRowInsets(EdgeInsets())
                        .padding(.top)
                    ){

                    }.unredacted()

                    Section(header: SectionHeader(title: "Lists", detail: {
                        NavigationLink(destination: ListCreateScreen(), isActive: $newList) {
                            Text("")
                        }
                        Menu(content: {
                            Button(action: {
                                newList = true
                            }) {
                                Label("New list", icon: .add)
                            }
                            Button(action: {}) {
                                Label("Import", icon: .import)
                            }
                        }) {
                            Icon(.add)
                        }
                    }).unredacted()) {
                        ForEach(repository.getAllLists()) { list in
                            NavigationLink(destination: GearListScreen(list: repository.binding(forList: list))) {
                                GearListCell(list: list)
                                    .redacted(reason: repository.isPlaceholder ? .placeholder : [])
                            }.unredacted()
                        }.onDelete(perform: removeList)
                    }.disabled(repository.isPlaceholder)

                    Section {
                        NavigationLink(destination: ItemsListScreen()) {
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
            .foregroundColor(Color(.label))
            .listRowInsets(EdgeInsets())
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
                .foregroundColor(Color(.secondaryLabel))
                .listRowBackground(Color(.systemGroupedBackground))
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
                                        Text("Error").foregroundColor(Color(.systemRed)).bold()
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
                .foregroundColor(Color(.secondaryLabel))
                .listRowBackground(Color(.systemGroupedBackground))
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
    }
}
