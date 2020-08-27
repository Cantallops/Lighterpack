//
//  ForgotScreen.swift
//  LighterPack
//
//  Created by acantallops on 2020/08/26.
//

import SwiftUI
import Combine

extension String: Identifiable {
    public var id: String { self }
}

struct ForgotScreen: View {
    @Environment(\.presentationMode) var presentationMode

    @EnvironmentObject var sessionStore: SessionStore

    @State private var usernameOrEmail: String = ""
    @State private var status: Status = .idle
    @State private var entryType: EntryType = .unknown
    @State private var successMessage: String?


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
        case error(Error)
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
                switch status {
                case .error(let error):
                    Text(error.localizedDescription)
                        .foregroundColor(Color(.systemRed))
                default:
                    EmptyView()
                }

            }) {
                HStack {
                    Icon(entryType.icon)
                        .frame(width: 25)
                    TextField(
                        "Enter username or email",
                        text: $usernameOrEmail,
                        onCommit: requestCredentials
                    )
                }
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
        .alert(item: $successMessage) { message in
            Alert(title: Text(message), dismissButton: .default(Text("Ok"), action: {
                presentationMode.wrappedValue.dismiss()
            }))
        }
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
            switch result {
            case .success(let message):
                successMessage = message
                status = .idle
            case .failure(let error):
                status = .error(error)
            }
        }
        status = .requesting
    }

    func recoverUsername() {
        sessionStore.forgotUsername(email: usernameOrEmail) { result in
            switch result {
            case .success(let message):
                successMessage = message
                status = .idle
            case .failure(let error):
                status = .error(error)
            }
        }
        status = .requesting
    }

    func validate() -> Bool {
        var message: String?
        if usernameOrEmail.isEmpty {
            message = "Please enter a username or an email."
        }
        if let message = message {
            status = .error(ValidationError(message: message))
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
