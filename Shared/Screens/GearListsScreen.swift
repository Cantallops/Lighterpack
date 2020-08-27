import SwiftUI

struct GearListsScreen: View {
    @EnvironmentObject var libraryStore: LibraryStore

    var body: some View {
        List {
            Section {
                ForEach(libraryStore.lists) { list in
                    NavigationLink(destination: GearListScreen(list: list)) {
                        GearListCell(list: list)
                    }
                }
            }

            Section {
                Button {

                } label: {
                    HStack {
                        Icon(.add)
                        Text("New list")
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
