import Entities
import SwiftUI
import DesignSystem
import Repository

struct ProfileScreen: View {

    @EnvironmentObject var visualFeedback: VisualFeedbackState
    @EnvironmentObject var repository: Repository

    var body: some View {
        Form {
            Section(header: SectionHeader(title: "Signed in as")) {
                cell(text: repository.username, icon: .profile)
                NavigationLink(destination: AccountSettingsScreen()) {
                    cell(text: "Account settings", icon: .accountSettings)
                }
            }

            Section(header: SectionHeader(title: "Settings")) {
                HStack {
                    cell(text: "Currency", icon: .currency)
                    TextField("Currency", text: $repository.currencySymbol)
                        .multilineTextAlignment(.trailing)
                }
                Toggle(isOn: $repository.showImages) {
                    cell(text: "Item images", icon: .images)
                }
                Toggle(isOn: $repository.showPrice) {
                    cell(text: "Item prices", icon: .price)
                }

                Toggle(isOn: $repository.showWorn) {
                    cell(text: "Worn items", icon: .worn)
                }
                Toggle(isOn: $repository.showConsumable) {
                    cell(text: "Consumable items", icon: .consumable)
                }
                Toggle(isOn: $repository.showListDescription) {
                    cell(text: "List descriptions", icon: .listDescription)
                }
                weightSelectorCell(text: "Total unit", binding: $repository.totalUnit, icon: .totalWeightUnit)
                weightSelectorCell(text: "Item unit", binding: $repository.itemUnit, icon: .itemWeightUnit)
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
        repository.logout()
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
