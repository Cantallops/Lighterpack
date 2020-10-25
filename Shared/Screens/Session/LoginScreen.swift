import SwiftUI
import Combine
import DesignSystem

struct LoginScreen: View {

    @EnvironmentObject var sessionStore: SessionStore
    @EnvironmentObject var visualFeedback: VisualFeedbackState
    @State private var password: String = ""

    @AppStorage(.username) private var username: String
    @State private var status: Status = .idle


    enum Status {
        case idle
        case signing
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

    private var isSigning: Bool {
        switch status {
        case .signing: return true
        default: return false
        }
    }

    var body: some View {
        Form {
            Section(footer: Group{
                if let error = status.otherError {
                    Text(error.localizedDescription)
                        .foregroundColor(Color(.systemRed))
                }
            }) {
                Field(
                    "Username",
                    text: $username,
                    icon: .profile,
                    error: status.formErrors.of(.username)?.message
                )
                Field(
                    "Password",
                    text: $password,
                    icon: .password,
                    secured: true,
                    error: status.formErrors.of(.password)?.message
                )
            }

            Section(
                footer: HStack {
                    Spacer()
                    NavigationLink("Forgot username/password?", destination: ForgotScreen())
                    .foregroundColor(Color(.systemBlue))
                }
                .listRowInsets(EdgeInsets())
                .padding(.top)
            ) {
                Button(action: signin, label: {
                    HStack {
                        Spacer()
                        if isSigning {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                        } else {
                            Text("Login")
                        }
                        Spacer()
                    }
                })
                .foregroundColor(Color.white)
                .listRowBackground(Color(.systemOrange))
            }
        }
        .navigationTitle("Sign in")
        .navigationBarItems(trailing: NavigationLink("Need to register?", destination: RegistrationScreen())
        )
        .disabled(isSigning)
    }

    func signin() {
        withAnimation {
            status = .signing
        }
        sessionStore.login(username: username, password: password) { result in
            withAnimation {
                switch result {
                case .success:
                    visualFeedback.notify(
                        .init(
                            message: "Logged in as \(username)",
                            style: .success
                        )
                    )
                    status = .idle
                case .failure(let error): status = .error(error)
                }
            }
        }
    }
}

struct LoginScreen_Previews: PreviewProvider {
    static var previews: some View {
        LoginScreen()
    }
}


