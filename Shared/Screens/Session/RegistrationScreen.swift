//
//  RegistrationScreen.swift
//  LighterPack
//
//  Created by acantallops on 2020/08/26.
//

import SwiftUI
import Combine

struct RegistrationScreen: View {
    @EnvironmentObject var sessionStore: SessionStore
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var passwordConfirmation: String = ""

    @State private var status: Status = .idle

    enum Status {
        case idle
        case registering
        case error(Error)
    }

    private var isRegistering: Bool {
        switch status {
        case .registering: return true
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
                    Icon(.email)
                        .frame(width: 25)
                    TextField("Email", text: $email)
                }
                HStack {
                    Icon(.password)
                        .frame(width: 25)
                    SecureField("Password", text: $password)
                }
                HStack {
                    Icon(.confirmPassword)
                        .frame(width: 25)
                    SecureField("Confirm password", text: $passwordConfirmation, onCommit: register)
                }
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
        guard validate() else { return }
    }

    func validate() -> Bool {
        var messages: [String] = []
        if sessionStore.username.isEmpty {
            messages.append("Please enter a username.")
        }
        if email.isEmpty {
            messages.append("Please enter an email.")
        }
        if password.isEmpty {
            messages.append("Please enter a password.")
        }
        if passwordConfirmation.isEmpty {
            messages.append("Please enter a password confirmation.")
        } else if passwordConfirmation != password {
            messages.append("The password confirmation does not match with the password.")
        }

        if !messages.isEmpty {
            status = .error(ValidationError(message: messages.joined(separator: "\n")))
            return false
        }
        return true
    }
}

struct RegistrationScreen_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationScreen()
    }
}
