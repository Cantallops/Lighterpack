import SwiftUI
import DesignSystem
import Repository

struct PasswordChangeScreen: Screen {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var repository: Repository
    @EnvironmentObject var visualFeedback: VisualFeedbackState

    @State private var currentPassword: String = ""
    @State private var newPassword: String = ""
    @State private var passwordConfirmation: String = ""

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

    var content: some View {
        List {
            Section {
                Field("Username", text: $repository.username, icon: .profile)
                    .disabled(true)
            }
            Section {
                Field(
                    "New password",
                    text: $newPassword,
                    icon: .password,
                    secured: true,
                    error: status.formErrors.of(.newPassword)?.message
                )

                Field(
                    "Confirm password",
                    text: $passwordConfirmation,
                    icon: .confirmPassword,
                    secured: true,
                    error: status.formErrors.of(.passwordConfirmation)?.message
                )
            }

            Section(footer: Group{
                if let error = status.otherError {
                    Text(error.localizedDescription)
                        .foregroundColor(.systemRed)
                }
            }) {
                Field(
                    "Current password",
                    text: $currentPassword,
                    icon: .password,
                    secured: true,
                    error: status.formErrors.of(.currentPassword)?.message
                )
            }
            Section {
                Button(action: changePassword, label: {
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
                .listRowBackgroundColor(.systemOrange)
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Change password")
        .disabled(isLoading)
    }

    func changePassword() {
        withAnimation {
            status = .requesting
        }
        repository.changePassword(
            username: repository.username,
            newPassword: newPassword,
            passwordConfirmation: passwordConfirmation,
            currentPassword: currentPassword
        ) { result in
            withAnimation {
                switch result {
                case .success:
                    success()
                    status = .idle
                case .failure(let error):
                    status = .error(error)
                }
            }
        }
    }

    func success() {
        visualFeedback.notify(
            .init(
                message: "Password changed successfully",
                style: .success
            )
        )
        presentationMode.wrappedValue.dismiss()
    }
}

struct PasswordChangeScreen_Previews: PreviewProvider {
    static var previews: some View {
        PasswordChangeScreen()
    }
}
