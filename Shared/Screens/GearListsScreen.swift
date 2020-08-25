import SwiftUI

struct GearListsScreen: View {
    @FetchRequest(
      entity: DBList.entity(),
      sortDescriptors: [
        NSSortDescriptor(keyPath: \DBList.order, ascending: true)
      ]
    ) var lists: FetchedResults<DBList>

    var body: some View {
        List {
            ForEach(lists) { (list: DBList) in
                NavigationLink(destination: GearListScreen(list: list)) {
                    GearListCell(list: list)
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
