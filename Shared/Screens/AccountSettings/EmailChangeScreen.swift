import SwiftUI

struct EmailChangeScreen: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var sessionStore: SessionStore

    @State private var email: String = ""
    @State private var currentPassword: String = ""
    @State private var successMessage: String?
    
    private var isLoading: Bool {
        switch status {
        case .requesting: return true
        default: return false
        }
    }

    @State private var status: Status = .idle

    enum Status {
        case idle
        case requesting
        case error(NetworkError.ErrorType)

        var formErrors: [FormErrorEntry] {
            switch self {
            case .error(let errorType):
                switch errorType {
                case .form(let errors): return errors
                default: return []
                }
            default:
                return []
            }
        }
        var otherError: Error? {
            switch self {
            case .error(let errorType):
                switch errorType {
                case .form: return nil
                default: return errorType
                }
            default:
                return nil
            }
        }
    }
    
    var body: some View {
        Form {
            Section {
                Field("Username", text: $sessionStore.username, icon: .profile)
                    .disabled(true)
                Field(
                    "New email",
                    text: $email,
                    icon: .email,
                    error: status.formErrors.of(.email)?.message
                )
            }

            Section {
                Field(
                    "Current password",
                    text: $currentPassword,
                    icon: .password,
                    secured: true,
                    error: status.formErrors.of(.currentPassword)?.message
                )
            }
            Section {
                Button(action: changeEmail, label: {
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
        .alert(item: $successMessage) { message in
            Alert(title: Text(message), dismissButton: .default(Text("Ok"), action: {
                presentationMode.wrappedValue.dismiss()
            }))
        }
    }

    func changeEmail() {
        withAnimation {
            status = .requesting
        }
        sessionStore.changeEmail(
            username: sessionStore.username,
            email: email,
            currentPassword: currentPassword
        ) { result in
            withAnimation {
                switch result {
                case .success:
                    successMessage = "Email changed successfully"
                    status = .idle
                case .failure(let error): status = .error(error)
                }
            }
        }
    }
}

struct EmailChangeScreen_Previews: PreviewProvider {
    static var previews: some View {
        EmailChangeScreen()
    }
}
