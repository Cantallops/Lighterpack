//
//  ProfileScreen.swift
//  LighterPack (iOS)
//
//  Created by acantallops on 2020/08/20.
//

import SwiftUI

struct ProfileScreen: View {
    @AppStorage(SettingKey.username.rawValue) var username: String = "Not logged"
    @AppStorage(SettingKey.optionalFieldWorn.rawValue) var showWorn: Bool = true
    @AppStorage(SettingKey.optionalFieldPrice.rawValue) var showPrice: Bool = true
    @AppStorage(SettingKey.optionalFieldImages.rawValue) var showImages: Bool = true
    @AppStorage(SettingKey.optionalFieldConsumable.rawValue) var showConsumable: Bool = true
    @AppStorage(SettingKey.optionalFieldListDescription.rawValue) var showListDescription: Bool = true
    @AppStorage(SettingKey.currencySymbol.rawValue) var currencySymbol: String = ""

    @AppStorage(SettingKey.itemUnit.rawValue) var itemUnit: WeigthUnit = .oz
    @AppStorage(SettingKey.totalUnit.rawValue) var totalUnit: WeigthUnit = .oz

    var body: some View {
        Form {
            Section(header: SectionHeader(title: "Signed in as")) {
                cell(text: username, icon: .profile)
                NavigationLink(destination: Text("Account settings")) {
                    cell(text: "Account settings", icon: .accountSettings)
                }
            }

            Section(header: SectionHeader(title: "Settings")) {
                HStack {
                    cell(text: "Currency", icon: .currency)
                    TextField("Currency", text: $currencySymbol)
                        .multilineTextAlignment(.trailing)
                }
                Toggle(isOn: $showImages) {
                    cell(text: "Item images", icon: .images)
                }
                Toggle(isOn: $showPrice) {
                    cell(text: "Item prices", icon: .price)
                }

                Toggle(isOn: $showWorn) {
                    cell(text: "Worn items", icon: .worn)
                }
                Toggle(isOn: $showConsumable) {
                    cell(text: "Consumable items", icon: .consumable)
                }
                Toggle(isOn: $showListDescription) {
                    cell(text: "List descriptions", icon: .listDescription)
                }
                weightSelectorCell(text: "Total unit", binding: $totalUnit, icon: .totalWeightUnit)
                weightSelectorCell(text: "Item unit", binding: $itemUnit, icon: .itemWeightUnit)
            }

            Section {
                NavigationLink(destination: Text("Help")) {
                    cell(text: "Help", icon: .help)
                }
            }
            Button {

            } label: {
                cell(text: "Sign Out", icon: .signOut)
            }.foregroundColor(Color(.systemRed))


        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Profile & Settings")
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

    private func weightSelectorCell(text: String, binding: Binding<WeigthUnit>, icon: Icon.Token, color: Color? = nil) -> some View {
        HStack {
            cell(text: text, icon: icon, color: color)
            Spacer()
            Picker(selection: binding, label: EmptyView()) {
                ForEach(WeigthUnit.allCases, id: \.rawValue) {
                    Text($0.rawValue).tag($0)
                }
            }.pickerStyle(SegmentedPickerStyle())
            .frame(width: 160)
        }
    }
}

struct ProfileScreen_Previews: PreviewProvider {
    static var previews: some View {
        ProfileScreen()
    }
}
