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
        case selectedCategoryItem(CategoryItem, Entities.Category)
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
                ListCategorySection(category: repository.binding(forCategory: category), listId: list.id, onSelectedCategoryItem: {
                    sheetStatus = .selectedCategoryItem($0, category)
                })
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
            case .selectedCategoryItem(let item, let category):
                NavigationView {
                    CategoryItemScreen(categoryItem: repository.binding(forCategoryItem: item, in: category))
                        .navigationBarItems(
                            trailing: Button(
                                action: { sheetStatus = nil },
                                label: {
                                    Icon(.close)
                                }
                            )
                        )
                }
                    .environmentObject(repository)
            }
        }
    }
}


struct CategoryItemScreen: Screen {
    @EnvironmentObject var repository: Repository
    @Binding var categoryItem: CategoryItem

    var item: Item? { repository.get(itemWithId: categoryItem.itemId) }

    var content: some View {
        SwiftUI.List {
            if let item = item {
                Section(header: SectionHeader(title: "Item")) {
                    NavigationLink(destination: ItemScreen(item: repository.binding(forItem: item))) {
                        ItemCell(item: item)
                    }
                }
            }

            Section {
                Stepper(value: $categoryItem.qty, in: 0...Int.max) {
                    cell(text: "Quantity: \(categoryItem.qty)", icon: .quantity)
                }
                Toggle(isOn: $categoryItem.worn) {
                    cell(text: "Is worn?", icon: .worn)
                }
                Toggle(isOn: $categoryItem.consumable) {
                    cell(text: "Is consumable?", icon: .consumable)
                }

                HStack {
                    cell(text: "Star", icon: .star, color: categoryItem.star.color)
                    Spacer()
                    Menu {
                       Picker(selection: $categoryItem.star, label: Text("Star")) {
                           ForEach(StarColor.allCases, id: \.rawValue) {
                               Label($0.title, icon: .star)
                                   .tag($0)
                                   .foregroundColor($0.color)
                           }
                       }
                    } label: {
                        Text(categoryItem.star.title)
                    }
                    .accentColor(categoryItem.star.color)
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(item?.name ?? "")
    }

    private func cell(text: String, icon: Icon.Token, color: Color? = nil, rendering: Icon.RenderingMode = .auto) -> some View {
        HStack {
            Icon(icon)
                .renderingMode(rendering)
                .foregroundColor(color)
                .frame(width: 25)
            Text(text)
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
