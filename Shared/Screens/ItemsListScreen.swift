import SwiftUI

struct ItemsListScreen: View {
    @FetchRequest(
      entity: DBItem.entity(),
      sortDescriptors: [
        NSSortDescriptor(keyPath: \DBItem.id, ascending: true)
      ]
    ) var items: FetchedResults<DBItem>

    var body: some View {
        List {
            ForEach(items) { (item: DBItem) in
                ItemCell(item: item)
            }
        }
        .navigationBarItems(trailing: Button(action: {

        }, label: {
            Icon(.add)
        }))
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Gear")
    }
}

struct ItemsListScreen_Previews: PreviewProvider {
    static var previews: some View {
        ItemsListScreen()
    }
}
