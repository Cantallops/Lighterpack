import SwiftUI
import Combine

struct LoginScreen: View {

    @EnvironmentObject var sessionStore: SessionStore
    @State private var password: String = ""

    @State private var status: Status = .idle

    enum Status {
        case idle
        case signing
        case error(Error)
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
                switch status {
                case .error(let error):
                    Text(error.localizedDescription)
                        .foregroundColor(Color(.systemRed))
                default:
                    EmptyView()
                }

            }) {
                HStack {
                    Icon(.profile)
                        .frame(width: 25)
                    TextField("Username", text: $sessionStore.username)
                }
                HStack {
                    Icon(.password)
                        .frame(width: 25)
                    SecureField("Password", text: $password, onCommit: signin)
                }
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
        guard validate() else { return }
        status = .signing
        sessionStore.login(username: sessionStore.username, password: password) { result in
            switch result {
            case .success: status = .idle
            case .failure(let error): status = .error(error)
            }
        }
    }

    func validate() -> Bool {
        var message: String?
        if sessionStore.username.isEmpty && password.isEmpty {
            message = "Please enter username and password."
        } else if sessionStore.username.isEmpty {
            message = "Please enter a username."
        } else if password.isEmpty {
            message = "Please enter a password."
        }
        if let message = message {
            status = .error(ValidationError(message: message))
            return false
        }
        return true
    }
}

struct LoginScreen_Previews: PreviewProvider {
    static var previews: some View {
        LoginScreen()
    }
}


struct ValidationError: Error {
    var message: String
}

extension ValidationError: LocalizedError {
    var errorDescription: String? { message }
}
