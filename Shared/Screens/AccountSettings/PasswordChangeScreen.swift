import SwiftUI

struct PasswordChangeScreen: View {
    @State private var currentPassword: String = ""
    @State private var newPassword: String = ""
    @State private var passwordConfirmation: String = ""

    private var isLoading: Bool { return false }

    var body: some View {
        Form {
            Section {
                HStack {
                    Icon(.password)
                        .frame(width: 25)
                    SecureField("New password", text: $newPassword)
                }
                HStack {
                    Icon(.confirmPassword)
                        .frame(width: 25)
                    SecureField("Confirm password", text: $passwordConfirmation)
                }
            }

            Section {
                HStack {
                    Icon(.password)
                        .frame(width: 25)
                    SecureField("Current password", text: $currentPassword)
                }
            }
            Section {
                Button(action: {}, label: {
                    HStack {
                        Spacer()
                        if isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                        } else {
                            Text("Change password")
                        }
                        Spacer()
                    }
                })
                .foregroundColor(Color.white)
                .listRowBackground(Color(.systemOrange))
            }
        }
        .navigationTitle("Change password")
        .disabled(isLoading)
    }
}

struct PasswordChangeScreen_Previews: PreviewProvider {
    static var previews: some View {
        PasswordChangeScreen()
    }
}
