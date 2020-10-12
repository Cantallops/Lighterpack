//
//  DeleteAccountScreen.swift
//  LighterPack (iOS)
//
//  Created by acantallops on 2020/08/27.
//

import SwiftUI

struct DeleteAccountScreen: View {
    @EnvironmentObject var sessionStore: SessionStore

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
                HStack(alignment: .top) {
                    Icon(.warning)
                    Text("This action is permanent and cannot be undone.")
                }
                .foregroundColor(Color(.systemYellow).darker(by: 0.5))
                .listRowBackground(Color(.systemYellow))
            }

            Section(footer: Group{
                if let error = status.otherError {
                    Text(error.localizedDescription)
                        .foregroundColor(Color(.systemRed))
                }
            }) {
                HStack(alignment: .top) {
                    Icon(.info)
                    Text("If you want to delete your account, please enter your current password and the text ") + Text("delete my account").bold()
                }
                .foregroundColor(Color(.white))
                .listRowBackground(Color(.systemBlue))
                Field("Username", text: $sessionStore.username, icon: .profile)
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
                .listRowBackground(Color(.systemRed))
            }
        }
        .navigationTitle("Delete account")
        .disabled(isLoading)
    }

    func deleteAccont() {
        withAnimation {
            status = .requesting
        }
        sessionStore.deleteAccount(
            username: sessionStore.username,
            currentPassword: currentPassword,
            confirmationText: confirmationText
        ) { result in
            withAnimation {
                switch result {
                case .success:
                    success()
                    status = .idle
                case .failure(let error): status = .error(error)
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