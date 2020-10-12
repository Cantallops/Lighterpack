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
    private var totalUnit: WeightUnit { settingsStore.totalUnit }
    private var showPrice: Bool { settingsStore.price }
    private var showDesc: Bool { settingsStore.listDescription }
    private var currencySymbol: String { settingsStore.currencySymbol }

    var list: GearList

    @State private var modificableList: GearList = .placeholder

    private enum SheetStatus {
        case edit
        case share
    }
    @State private var sheetStatus: SheetStatus?

    var body: some View {
        List {
            GearListPieSection(list: list)
            Section(header: SectionHeader(title: "Title")) {
                TextField("Title", text: $modificableList.name)
            }
            if showDesc {
                Section(header: SectionHeader(title: "Description")) {
                    TextEditor(text: $modificableList.description)
                        .frame(maxHeight: 300)
                }
            }
            ForEach(libraryStore.categories(ofList: modificableList)) { (category: Category) in
                GearListCategorySection(category: category, list: modificableList)
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
        .navigationTitle(modificableList.name)
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
        }.onAppear {
            if modificableList.isPlaceholder {
                modificableList = list
            }
        }.onChange(of: modificableList) { list in
            libraryStore.replace(list: list)
        }
    }
}

/*struct GearListScreen_Previews: PreviewProvider {
    static var previews: some View {
        GearListScreen()
    }
}*/
