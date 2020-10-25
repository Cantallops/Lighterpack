import SwiftUI
import Entities
import DesignSystem

struct HomeScreen: View {
    @EnvironmentObject var sessionStore: SessionStore
    @EnvironmentObject var libraryStore: LibraryStore

    @State private var isShowingSettings = false

    var body: some View {
        if sessionStore.isLoggedIn {
            NavigationView {
                List {
                    Section(header: SectionHeader(title: "Lists", detail: {
                        Menu(content: {
                            Button(action: {}) {
                                Label("New list", icon: .add)
                            }
                            Button(action: {}) {
                                Label("Import", icon: .link)
                            }
                        }) {
                            Icon(.add)
                        }
                    })) {
                        ForEach(libraryStore.lists) { list in
                            NavigationLink(destination: GearListScreen(list: libraryStore.binding(forList: list))) {
                                GearListCell(list: list)
                            }
                        }
                    }

                    Section {
                        NavigationLink(destination: ItemsListScreen()) {
                            Label("All gear", icon: .gearList)
                        }
                    }

                    footer

                }
                .listStyle(InsetGroupedListStyle())
                .navigationBarTitle("LighterPack")
            }
            .sheet(isPresented: $isShowingSettings) {
                NavigationView {
                    ProfileScreen()
                }
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
                    switch libraryStore.status {
                    case .idle: EmptyView()
                    case .loading:
                        HStack {
                            Spacer()
                            ProgressView("Updating")
                            Spacer()
                        }
                    case .unsync:
                        Button(action: {}) {
                            VStack {
                                HStack {
                                    Spacer()
                                    Text("Not sync with LighterPack server")
                                    Spacer()
                                }
                                Text("Sync now").foregroundColor(.accentColor)
                            }
                        }
                    case .loaded(let date):
                        HStack {
                            Spacer()
                            Text("Updated \(date)")
                            Spacer()
                        }
                    case .error(let error, let date):
                        HStack {
                            Spacer()
                            Icon(.warning)
                            Text("Error \(error.localizedDescription) \(date)")
                            Spacer()
                        }
                    }
                }
                .font(.system(.footnote, design: .rounded))
                .multilineTextAlignment(.center)
                .foregroundColor(Color(.secondaryLabel))
                .listRowBackground(Color(.systemGroupedBackground))
            }
        }
    }

    func showSettings() {
        isShowingSettings = true
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
    }
}
