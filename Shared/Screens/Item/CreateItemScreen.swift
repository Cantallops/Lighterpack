import DesignSystem
import Entities
import Repository
import SwiftUI

struct CreateItemScreen: Screen {
    @EnvironmentObject var repository: Repository
    @Environment(\.presentationMode) var presentationMode

    private var numberFormatter: NumberFormatter {
        let numberFormatter = NumberFormatter()
        numberFormatter.allowsFloats = true
        numberFormatter.alwaysShowsDecimalSeparator = true
        numberFormatter.minimumFractionDigits = 2
        numberFormatter.maximumFractionDigits = 2
        return numberFormatter
    }
    @State var item: Item = Item(
        id: .min,
        name: "",
        description: "",
        weight: 0,
        authorUnit: .g,
        price: 0,
        image: "",
        imageUrl: "",
        url: ""
    )

    var onCreate: ((Item) -> Void)? = nil

    var content: some View {
        ItemScreen(item: $item)
            .navigationBarItems(
                leading: Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("Cancel")
                }.accentColor(.systemRed),
                trailing: Button {
                    item = repository.create(item: item)
                    presentationMode.wrappedValue.dismiss()
                    onCreate?(item)
                } label: {
                    Text("Save")
                }
            )
            .onFirstAppear {
                item.authorUnit = repository.itemUnit
            }
    }
}
