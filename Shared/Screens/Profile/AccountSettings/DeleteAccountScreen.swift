import SwiftUI
import DesignSystem
import Repository

struct DeleteAccountScreen: Screen {
    @EnvironmentObject var repository: Repository

    @State private var currentPassword: String = ""
    @State private var confirmationText: String = ""
    @EnvironmentObject var visualFeedback: VisualFeedbackState

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
        Form {
            Section {
                HStack(alignment: .top) {
                    Icon(.warning)
                    Text("This action is permanent and cannot be undone.")
                }
                .foregroundColor(Color.systemYellow.darker(by: 0.5))
                .listRowBackgroundColor(.systemYellow)
            }

            Section(footer: Group{
                if let error = status.otherError {
                    Text(error.localizedDescription)
                        .foregroundColor(.systemRed)
                }
            }) {
                HStack(alignment: .top) {
                    Icon(.info)
                    Text("If you want to delete your account, please enter your current password and the text ") + Text("delete my account").bold()
                }
                .foregroundColor(.white)
                .listRowBackgroundColor(.systemBlue)
                Field("Username", text: $repository.username, icon: .profile)
                    .disabled(true)
                Field(
                    "Current password",
                    text: $currentPassword,
                    icon: .password,
                    secured: true,
                    error: status.formErrors.of(.currentPassword)?.message
                )
                Field(
                    "Confirmation text",
                    text: $confirmationText,
                    icon: .confirmation,
                    error: status.formErrors.of(.confirmationText)?.message
                )
            }
            Section {
                Button(action: deleteAccont, label: {
                    HStack {
                        Spacer()
                        if isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                        } else {
                            Text("Delete account")
                        }
                        Spacer()
                    }
                })
                .foregroundColor(Color.white)
                .listRowBackgroundColor(.systemRed)
            }
        }
        .navigationTitle("Delete account")
        .disabled(isLoading)
    }

    func deleteAccont() {
        withAnimation {
            status = .requesting
        }
        repository.deleteAccount(
            username: repository.username,
            currentPassword: currentPassword,
            confirmationText: confirmationText
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
                message: "Account deleted permanently",
                style: .success
            )
        )
    }
}

struct DeleteAccountScreen_Previews: PreviewProvider {
    static var previews: some View {
        DeleteAccountScreen()
    }
}
