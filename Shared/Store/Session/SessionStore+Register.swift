//
//  SessionStore+Register.swift
//  LighterPack (iOS)
//
//  Created by acantallops on 2020/08/27.
//

import Foundation
import Combine

extension SessionStore {
    func register(
        email: String,
        username: String,
        password: String,
        passwordConfirmation: String,
        completion: @escaping (Result<Void, NetworkError.ErrorType>) -> Void
    ) {
        var errors: [FormErrorEntry] = []
        if username.isEmpty {
            errors.append(.init(field: .username, message: "Please enter a username."))
        }
        if email.isEmpty {
            errors.append(.init(field: .email, message: "Please enter an email."))
        }
        if password.isEmpty {
            errors.append(.init(field: .password, message: "Please enter a passwod."))
        }
        if passwordConfirmation.isEmpty {
            errors.append(.init(field: .passwordConfirmation, message: "Please enter a password confirmation."))
        } else if passwordConfirmation != password {
            errors.append(.init(field: .passwordConfirmation, message: "The password confirmation does not match with the password."))
        }

        if !errors.isEmpty {
            completion(.failure(.form(errors)))
            return
        }
        let endpoint = RegisterEndpoint(email: email, username: username, password: password)
        networkAccess
            .request(endpoint)
            .sink(receiveCompletion: { result in
                switch result {
                case .finished:
                    completion(.success(()))
                    self.sessionCookie = self.networkAccess.cookieSubject.value
                case .failure(let error):
                    guard let networkError = error as? NetworkError else {
                        completion(.failure(.unknown))
                        return
                    }
                    completion(.failure(networkError.error))
                }
            }, receiveValue: { _ in }
            ).store(in: &cancellables)
    }
}
