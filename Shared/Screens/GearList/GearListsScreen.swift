import SwiftUI
import DesignSystem

struct GearListsScreen: View {
    @EnvironmentObject var libraryStore: LibraryStore

    var body: some View {
        List {
            Section {
                Button {

                } label: {
                    HStack {
                        Icon(.add)
                        Text("New list")
                    }
                }
            }

            Section {
                ForEach(libraryStore.lists) { list in
                    NavigationLink(destination: GearListScreen(list: libraryStore.binding(forList: list))) {
                        GearListCell(list: list)
                    }
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Lists")
    }
}

struct ListsScreen_Previews: PreviewProvider {
    static var previews: some View {
        GearListsScreen()
    }
}
