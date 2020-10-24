//
//  GearListScreen.swift
//  LighterPack (iOS)
//
//  Created by acantallops on 2020/08/19.
//

import SwiftUI
import Combine

struct GearListScreen: View {
    @EnvironmentObject var libraryStore: LibraryStore
    @EnvironmentObject var settingsStore: SettingsStore

    @AppSetting(.totalUnit) private var totalUnit: WeightUnit
    @AppSetting(.showPrice) private var showPrice: Bool
    @AppSetting(.showListDescription) private var showDesc: Bool
    @AppSetting(.currencySymbol) private var currencySymbol: String

    @Binding var list: GearList

    private enum SheetStatus {
        case share
    }
    @State private var sheetStatus: SheetStatus?

    var body: some View {
        List {
            GearListPieSection(list: list)
            Section(header: SectionHeader(title: "Title")) {
                TextField("Title", text: $list.name)
            }
            if showDesc {
                Section(header: SectionHeader(title: "Description")) {
                    TextEditor(text: $list.description)
                        .frame(maxHeight: 300)
                }
            }
            ForEach(libraryStore.categories(ofList: list)) { (category: Category) in
                GearListCategorySection(category: libraryStore.binding(forCategory: category), list: list)
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
