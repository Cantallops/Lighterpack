//
//  GearListScreen.swift
//  LighterPack (iOS)
//
//  Created by acantallops on 2020/08/19.
//

import SwiftUI
import Combine

struct GearListScreen: View {
    @AppStorage(SettingKey.totalUnit.rawValue) var totalUnit: WeigthUnit = .oz
    @AppStorage(SettingKey.optionalFieldPrice.rawValue) var showPrice: Bool = true
    @AppStorage(SettingKey.optionalFieldListDescription.rawValue) var showDesc: Bool = true
    @AppStorage(SettingKey.currencySymbol.rawValue) var currencySymbol: String = ""

    @ObservedObject var list: DBList

    @Environment(\.editMode) var editMode
    private var isEditing: Bool { editMode?.wrappedValue == .active }

    var body: some View {
        Form {
            if isEditing {
                TextField("Title's name", text: $list.name)
            } else {
                GearListPieSection(list: list)
            }

            if showDesc {
                Section(header: SectionHeader(title: "Description")) {
                    if isEditing {
                        TextEditor(text: $list.desc)
                            .frame(minHeight: 100)
                    } else {
                        Text(list.desc)
                    }
                }
            }
            ForEach(list.categoriesArray) { (category: DBCategory) in
                GearListCategorySection(category: category)
            }
            if !isEditing {
                Section {
                    Button {

                    } label: {
                        HStack {
                            Icon(.addCategory)
                            Text("Add category")
                        }
                    }
                }

                Section {
                    Button {

                    } label: {
                        HStack {
                            Icon(.remove)
                            Text("Remove list")
                        }
                    }.foregroundColor(Color(.systemRed))
                }
            }
        }
        .navigationBarItems(trailing: EditButton())
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(list.name)
    }
}

/*struct GearListScreen_Previews: PreviewProvider {
    static var previews: some View {
        GearListScreen()
    }
}*/
