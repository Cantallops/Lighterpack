import SwiftUI

struct EmailChangeScreen: View {
    @State private var email: String = ""
    @State private var currentPassword: String = ""

    private var isLoading: Bool { return false }

    var body: some View {
        Form {
            Section {
                HStack {
                    Icon(.email)
                        .frame(width: 25)
                    TextField("New email", text: $email)
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
                            Text("Change email")
                        }
                        Spacer()
                    }
                })
                .foregroundColor(Color.white)
                .listRowBackground(Color(.systemOrange))
            }
        }
        .navigationTitle("Change email")
        .disabled(isLoading)
    }
}

struct EmailChangeScreen_Previews: PreviewProvider {
    static var previews: some View {
        EmailChangeScreen()
    }
}
