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

    private enum SheetStatus {
        case edit
        case share
    }
    @State private var sheetStatus: SheetStatus?

    var body: some View {
        List {
            GearListPieSection(list: list)

            if showDesc {
                Section(header: SectionHeader(title: "Description")) {
                    Text(list.desc)
                }
            }
            ForEach(list.categoriesArray) { (category: DBCategory) in
                GearListCategorySection(category: category)
            }
            Section {
                Button {
                    sheetStatus = .edit
                } label: {
                    HStack {
                        Icon(.editList)
                        Text("Edit list")
                    }
                }
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
            case .edit: Text("Editing")
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
