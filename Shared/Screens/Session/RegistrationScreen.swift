import SwiftUI
import Combine
import DesignSystem
import Repository

struct RegistrationScreen: Screen {
    @EnvironmentObject var repository: Repository

    @EnvironmentObject var visualFeedback: VisualFeedbackState
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var passwordConfirmation: String = ""

    @State private var status: Status = .idle

    enum Status {
        case idle
        case registering
        case error(RepositoryError.ErrorType)

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

    private var isRegistering: Bool {
        switch status {
        case .registering: return true
        default: return false
        }
    }

    var content: some View {
        Form {
            Section(footer: Group{
                if let error = status.otherError {
                    Text(error.localizedDescription)
                        .foregroundColor(Color(.systemRed))
                }
            })  {
                Field(
                    "Username",
                    text: $repository.username,
                    icon: .profile,
                    error: status.formErrors.of(.username)?.message
                )
                Field(
                    "Email",
                    text: $email,
                    icon: .email,
                    error: status.formErrors.of(.email)?.message
                )
                Field(
                    "Password",
                    text: $password,
                    icon: .password,
                    secured: true,
                    error: status.formErrors.of(.password)?.message
                )
                Field(
                    "Confirm password",
                    text: $passwordConfirmation,
                    icon: .confirmPassword,
                    secured: true,
                    error: status.formErrors.of(.passwordConfirmation)?.message
                )
            }

            Section {
                Button(action: register, label: {
                    HStack {
                        Spacer()
                        if isRegistering {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                        } else {
                            Text("Register")
                        }
                        Spacer()
                    }
                })
                .foregroundColor(Color.white)
                .listRowBackground(Color(.systemOrange))
            }
        }
        .navigationTitle("Register an account")
        .disabled(isRegistering)
    }

    func register() {
        withAnimation {
            status = .registering
        }
        repository.register(
            email: email,
            username: repository.username,
            password: password,
            passwordConfirmation: passwordConfirmation
        ) { result in
            withAnimation {
                switch result {
                case .success:
                    visualFeedback.notify(
                        .init(
                            message: "Register as \(repository.username)",
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

struct RegistrationScreen_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationScreen()
    }
}
