import Foundation
import Entities
import Combine

public extension Repository {
    var username: String {
        get { localRepo.username }
        set { localRepo.username = newValue }
    }

    var isLoggedIn: Bool {
        return localRepo.cookie != nil
    }

    func logout() {
        remoteRepo.logout(username: username)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                switch result {
                case .finished: break
                case .failure: break
                }
                self?.syncEngine.stop()
                self?.localRepo.logout()
            } receiveValue: { _ in

            }.store(in: &cancellables)
    }

    func login(
        username: String,
        password: String,
        completion: @escaping (Result<Void, RepositoryError.ErrorType>) -> Void
    ) {
        var errors: [FormErrorEntry] = []
        if username.isEmpty {
            errors.append(.init(field: .username, message: "Please enter a username."))
        }
        if password.isEmpty {
            errors.append(.init(field: .password, message: "Please enter a password."))
        }
        if !errors.isEmpty {
            logger.error("❌ \(#function) \(errors.map{ $0.message }.joined(separator: ","))")
            completion(.failure(.form(errors)))
            return
        }
        remoteRepo.login(username: username, password: password)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { result in
                switch result {
                case .finished:
                    completion(.success(()))
                case .failure(let error):
                    guard let networkError = error as? RepositoryError else {
                        completion(.failure(.unknown))
                        return
                    }
                    completion(.failure(networkError.error))
                }
            }, receiveValue: { [weak self] cookie in
                self?.localRepo.cookie = cookie
                self?.syncEngine.sync(forced: true)
            }
        ).store(in: &cancellables)
    }

    func register(
        email: String,
        username: String,
        password: String,
        passwordConfirmation: String,
        completion: @escaping (Result<Void, RepositoryError.ErrorType>) -> Void
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
            logger.error("❌ \(#function) \(errors.map{ $0.message }.joined(separator: ","))")
            completion(.failure(.form(errors)))
            return
        }
        remoteRepo
            .register(email: email, username: username, password: password)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { result in
                switch result {
                case .finished:
                    completion(.success(()))
                case .failure(let error):
                    guard let networkError = error as? RepositoryError else {
                        completion(.failure(.unknown))
                        return
                    }
                    completion(.failure(networkError.error))
                }
            }, receiveValue: { _ in }
            ).store(in: &cancellables)
    }

    func changeEmail(
        username: String,
        email: String,
        currentPassword: String,
        completion: @escaping (Result<Void, RepositoryError.ErrorType>) -> Void
    ) {
        guard let cookie = localRepo.cookie else {
            completion(.failure(.message("No user is signed in")))
            return
        }
        var errors: [FormErrorEntry] = []
        if email.isEmpty {
            errors.append(.init(field: .email, message: "Please enter a new email."))
        }
        if currentPassword.isEmpty {
            errors.append(.init(field: .currentPassword, message: "Please enter your current password."))
        }
        if !errors.isEmpty {
            logger.error("❌ \(#function) \(errors.map{ $0.message }.joined(separator: ","))")
            completion(.failure(.form(errors)))
            return
        }
        remoteRepo.changeEmail(with: email, ofUsername: username, password: currentPassword, cookie: cookie)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { result in
                switch result {
                case .finished:
                    completion(.success(()))
                case .failure(let error):
                    guard let networkError = error as? RepositoryError else {
                        completion(.failure(.unknown))
                        return
                    }
                    completion(.failure(networkError.error))
                }
            }, receiveValue: { _ in }
        ).store(in: &cancellables)
    }

    func forgotPassword(
        username: String,
        completion: @escaping (Result<String, RepositoryError.ErrorType>) -> Void
    ) {
        remoteRepo
            .forgotPassword(ofUsername: username)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { result in
                switch result {
                case .finished: completion(.success("An email has been sent to the address associated with your account."))
                    self.username = username
                case .failure(let error):
                    guard let networkError = error as? RepositoryError else {
                        completion(.failure(.unknown))
                        return
                    }
                    completion(.failure(networkError.error))
                }
            },
            receiveValue: { _ in }
        )
        .store(in: &cancellables)
    }

    func forgotUsername(
        email: String,
        completion: @escaping (Result<String, RepositoryError.ErrorType>) -> Void
    ) {
        remoteRepo.forgotPassword(ofUsername: username)
            .sink(receiveCompletion: { result in
                switch result {
                case .finished: completion(.success("An email has been sent to the address associated with your account."))
                case .failure(let error):
                    guard let networkError = error as? RepositoryError else {
                        completion(.failure(.unknown))
                        return
                    }
                    completion(.failure(networkError.error))
                }
            },
            receiveValue: { _ in }
        )
        .store(in: &cancellables)
    }

    func changePassword(
        username: String,
        newPassword: String,
        passwordConfirmation: String,
        currentPassword: String,
        completion: @escaping (Result<Void, RepositoryError.ErrorType>) -> Void
    ) {
        guard let cookie = localRepo.cookie else {
            completion(.failure(.message("No user is signed in")))
            return
        }
        var errors: [FormErrorEntry] = []
        if newPassword.isEmpty {
            errors.append(.init(field: .newPassword, message: "Please enter a new password."))
        }
        if passwordConfirmation.isEmpty {
            errors.append(.init(field: .passwordConfirmation, message: "Please enter a password confirmation."))
        } else if passwordConfirmation != newPassword {
            errors.append(.init(field: .passwordConfirmation, message: "The password confirmation does not match with the password."))
        }
        if currentPassword.isEmpty {
            errors.append(.init(field: .currentPassword, message: "Please enter your current password."))
        }
        if !errors.isEmpty {
            logger.error("❌ \(#function) \(errors.map{ $0.message }.joined(separator: ","))")
            completion(.failure(.form(errors)))
            return
        }

        remoteRepo.changePassword(
            ofUsername: username,
            password: currentPassword,
            newPassword: newPassword,
            cookie: cookie
        )
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { result in
                switch result {
                case .finished:
                    completion(.success(()))
                case .failure(let error):
                    guard let networkError = error as? RepositoryError else {
                        completion(.failure(.unknown))
                        return
                    }
                    completion(.failure(networkError.error))
                }
            }, receiveValue: { _ in }
        ).store(in: &cancellables)
    }
    
    func deleteAccount(
        username: String,
        currentPassword: String,
        confirmationText: String,
        completion: @escaping (Result<Void, RepositoryError.ErrorType>) -> Void
    ) {
        guard let cookie = localRepo.cookie else {
            completion(.failure(.message("No user is signed in")))
            return
        }
        var errors: [FormErrorEntry] = []
        if currentPassword.isEmpty {
            errors.append(.init(field: .currentPassword, message: "Please enter your current password."))
        }
        if confirmationText.isEmpty {
            errors.append(.init(field: .confirmationText, message: "Please enter the confirmation text."))
        } else if confirmationText.lowercased() != "delete my account" {
            errors.append(.init(field: .confirmationText, message: "It is not valid. Please enter 'delete my account' in other to delete it."))
        }
        if !errors.isEmpty {
            logger.error("❌ \(#function) \(errors.map{ $0.message }.joined(separator: ","))")
            completion(.failure(.form(errors)))
            return
        }
        remoteRepo.deleteAccount(
            username: username,
            password: currentPassword,
            cookie: cookie
        )
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { result in
                switch result {
                case .finished:
                    completion(.success(()))
                    self.logout()
                case .failure(let error):
                    guard let networkError = error as? RepositoryError else {
                        completion(.failure(.unknown))
                        return
                    }
                    completion(.failure(networkError.error))
                }
            }, receiveValue: { _ in }
        ).store(in: &cancellables)
    }
}
