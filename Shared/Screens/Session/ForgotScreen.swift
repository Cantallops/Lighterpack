//
//  ForgotScreen.swift
//  LighterPack
//
//  Created by acantallops on 2020/08/26.
//

import SwiftUI
import Combine

struct ForgotScreen: View {
    @Environment(\.presentationMode) var presentationMode

    @EnvironmentObject var sessionStore: SessionStore
    @EnvironmentObject var visualFeedback: VisualFeedbackState

    @State private var usernameOrEmail: String = ""
    @State private var status: Status = .idle
    @State private var entryType: EntryType = .unknown


    enum EntryType {
        case unknown
        case email
        case username

        var icon: Icon.Token {
            switch self {
            case .unknown: return .questionMark
            case .email: return .email
            case .username: return .profile
            }
        }

        var recoverSubmitText: String {
            switch self {
            case .unknown: return "Submit"
            case .email: return "Recover username"
            case .username: return "Recover password"
            }
        }
    }

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

    private var isRequesting: Bool {
        switch status {
        case .requesting: return true
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
                    "Enter username or email",
                    text: $usernameOrEmail,
                    icon: entryType.icon,
                    error: (status.formErrors.of(.username) ?? status.formErrors.of(.email))?.message
                )
            }

            Section {
                Button(action: requestCredentials, label: {
                    HStack {
                        Spacer()
                        if isRequesting {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                        } else {
                            Text(entryType.recoverSubmitText)
                        }
                        Spacer()
                    }
                })
                .foregroundColor(Color.white)
                .listRowBackground(Color(.systemOrange))
            }
        }
        .navigationTitle("Forgot credentials")
        .disabled(isRequesting)
        .onChange(of: usernameOrEmail, perform: evaluateEntryType)

    }

    func requestCredentials() {
        guard validate() else { return }
        switch entryType {
        case .unknown: return
        case .email: recoverUsername()
        case .username: recoverPassword()
        }
    }

    func recoverPassword() {
        sessionStore.forgotPassword(username: usernameOrEmail) { result in
            withAnimation {
                switch result {
                case .success(let message):
                    successMessage(message)
                    status = .idle
                case .failure(let error):
                    status = .error(error)
                }
            }
        }
        withAnimation {
            status = .requesting
        }
    }

    func recoverUsername() {
        sessionStore.forgotUsername(email: usernameOrEmail) { result in
            withAnimation {
                switch result {
                case .success(let message):
                    successMessage(message)
                    status = .idle
                case .failure(let error):
                    status = .error(error)
                }
            }
        }
        withAnimation {
            status = .requesting
        }
    }

    func successMessage(_ message: String) {
        visualFeedback.notify(
            .init(
                message: message,
                style: .success
            )
        )
        presentationMode.wrappedValue.dismiss()
    }

    func validate() -> Bool {
        if usernameOrEmail.isEmpty {
            withAnimation {
                status = .error(.form([.init(field: .username, message: "Please enter a username or an email.")]))
            }
            return false
        }
        return true
    }

    func evaluateEntryType(_ entry: String) {
        guard !entry.isEmpty else {
            entryType = .unknown
            return
        }
        if entry.contains("@") {
            entryType = .email
            return
        }
        entryType = .username
    }
}

struct ForgotScreen_Previews: PreviewProvider {
    static var previews: some View {
        ForgotScreen()
    }
}
