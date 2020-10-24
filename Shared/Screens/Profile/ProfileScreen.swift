//
//  ProfileScreen.swift
//  LighterPack (iOS)
//
//  Created by acantallops on 2020/08/20.
//

import SwiftUI

struct ProfileScreen: View {

    @EnvironmentObject var visualFeedback: VisualFeedbackState

    @EnvironmentObject var sessionStore: SessionStore

    @AppStorage(.username) private var username: String

    @AppSetting(.currencySymbol) private var currencySymbol: String
    @AppSetting(.itemUnit) private var itemUnit: WeightUnit
    @AppSetting(.totalUnit) private var totalUnit: WeightUnit
    @AppSetting(.showPrice) private var showPrice: Bool
    @AppSetting(.showWorn) private var showWorn: Bool
    @AppSetting(.showImages) private var showImages: Bool
    @AppSetting(.showConsumable) private var showConsumable: Bool
    @AppSetting(.showListDescription) private var showListDescription: Bool

    var body: some View {
        Form {
            Section(header: SectionHeader(title: "Signed in as")) {
                cell(text: username, icon: .profile)
                NavigationLink(destination: AccountSettingsScreen()) {
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
            Button(action: logout) {
                cell(text: "Sign Out", icon: .signOut)
            }.foregroundColor(Color(.systemRed))


        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Profile & Settings")
    }

    func logout() {
        sessionStore.logout()
        visualFeedback.notify(
            .init(
                message: "Logged out succesfully",
                style: .success
            )
        )
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

    private func weightSelectorCell(text: String, binding: Binding<WeightUnit>, icon: Icon.Token, color: Color? = nil) -> some View {
        HStack {
            cell(text: text, icon: icon, color: color)
            Spacer()
            Picker(selection: binding, label: EmptyView()) {
                ForEach(WeightUnit.allCases, id: \.rawValue) {
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
