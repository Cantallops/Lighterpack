import Entities
import SwiftUI
import Combine
import DesignSystem
import Repository

struct ListScreen: Screen {
    @EnvironmentObject var repository: Repository

    @Binding var list: Entities.List

    private enum SheetStatus {
        case share
        case editCategories
    }
    @State private var sheetStatus: SheetStatus?

    var content: some View {
        SwiftUI.List {
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

            Section {
                Button(action: {
                    repository.create(category: Entities.Category(), forListWithId: list.id)
                }, label: {
                    Label("Add new category", icon: .addCategory)
                })
                Button(action: {
                    sheetStatus = .editCategories
                }, label: {
                    Label("Rearrange categories", icon: .rearrange)
                })
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
            case .editCategories:
                NavigationView {
                    EditCategoriesView(list: $list)
                        .navigationBarItems(
                            trailing: Button(
                                action: { sheetStatus = nil },
                                label: {
                                    Icon(.close)
                                }))
                }
                .environmentObject(repository)
            }
        }
    }
}

struct EditCategoriesView: View {
    @EnvironmentObject var repository: Repository

    @Binding var list: Entities.List

    var body: some View {
        SwiftUI.List {
            ForEach(list.categoryIds.compactMap({ repository.get(categoryWithId: $0)})) { (category: Entities.Category) in
                HStack {
                    Text(category.name)
                }
            }
            .onDelete(perform: removeCategories)
            .onMove(perform: moveCategories)
        }
        .navigationTitle("Edit categories")
        .listStyle(InsetGroupedListStyle())
        .environment(\.editMode, .constant(.active))
    }

    private func removeCategories(in indices: IndexSet) {
        indices.forEach { index in
            repository.remove(categoryWithId: list.categoryIds[index])
        }
    }

    private func moveCategories(from: IndexSet, to: Int) {
        repository.move(categoriesInListWithId: list.id, from: from, to: to)
    }
}

/*struct GearListScreen_Previews: PreviewProvider {
    static var previews: some View {
        GearListScreen()
    }
}*/
