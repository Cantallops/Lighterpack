import Entities
import SwiftUI
import Combine
import DesignSystem
import Repository

struct ListScreen: View {
    @EnvironmentObject var repository: Repository

    @Binding var list: Entities.List

    private enum SheetStatus {
        case share
    }
    @State private var sheetStatus: SheetStatus?

    var body: some View {
        List {
            ListPieSection(list: list)
            Section(header: SectionHeader(title: "Title")) {
                TextField("Title", text: $list.name)
            }
            if repository.showListDescription {
                Section(header: SectionHeader(title: "Description")) {
                    TextEditor(text: $list.description)
                        .frame(maxHeight: 300)
                }
            }

            ForEach(list.categoryIds.compactMap({ repository.get(categoryWithId: $0)})) { (category: Entities.Category) in
                ListCategorySection(category: repository.binding(forCategory: category))
            }
        }
        .navigationBarItems(trailing: Button {
            if list.shareUrl == nil {
                //load url
            } else {
                sheetStatus = .share
            }
        } label: {
            Icon(.share)
        })
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(list.name)
        .sheet(isPresented: .init(get: {
            return sheetStatus != nil
        }, set: {
            if !$0 { sheetStatus = nil }
        })) {
            switch sheetStatus {
            case .none: EmptyView()
            case .share: ShareSheet(activityItems: [list.shareUrl!])
            }
        }
    }
}

/*struct GearListScreen_Previews: PreviewProvider {
    static var previews: some View {
        GearListScreen()
    }
}*/
