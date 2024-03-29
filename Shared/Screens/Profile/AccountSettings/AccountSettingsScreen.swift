import SwiftUI
import DesignSystem

struct AccountSettingsScreen: Screen {

    var content: some View {
        List {
            Section {
                NavigationLink(destination: EmailChangeScreen()) {
                    cell(text: "Change email", icon: .email)
                }
                NavigationLink(destination: PasswordChangeScreen()) {
                    cell(text: "Change password", icon: .password)
                }
            }

            NavigationLink(destination: DeleteAccountScreen()) {
                cell(text: "Delete account", icon: .remove, rendering: .template).foregroundColor(.systemRed)
            }

        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Account settings")
    }

    private func cell(text: String, icon: Icon.Token, color: Color? = nil, rendering: Icon.RenderingMode = .auto) -> some View {
        HStack {
            Icon(icon)
                .renderingMode(rendering)
                .frame(width: 25)
            Text(text)
        }
    }

}

struct AccountSettingsScreen_Previews: PreviewProvider {
    static var previews: some View {
        AccountSettingsScreen()
    }
}
