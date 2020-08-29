import Foundation
import Combine

extension SessionStore {
    func changePassword(
        username: String,
        newPassword: String,
        passwordConfirmation: String,
        currentPassword: String,
        completion: @escaping (Result<Void, NetworkError.ErrorType>) -> Void
    ) {
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
            completion(.failure(.form(errors)))
            return
        }
        let endpoint = ChangePasswordEndpoint(username: username, currentPassword: currentPassword, newPassword: newPassword)
        networkAccess
            .request(endpoint)
            .sink(receiveCompletion: { result in
                switch result {
                case .finished:
                    self.sessionCookie = self.networkAccess.cookieSubject.value
                    completion(.success(()))
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
