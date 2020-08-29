import Foundation
import Combine

extension SessionStore {
    func changeEmail(
        username: String,
        email: String,
        currentPassword: String,
        completion: @escaping (Result<Void, NetworkError.ErrorType>) -> Void
    ) {
        var errors: [FormErrorEntry] = []
        if email.isEmpty {
            errors.append(.init(field: .email, message: "Please enter a new email."))
        }
        if currentPassword.isEmpty {
            errors.append(.init(field: .currentPassword, message: "Please enter your current password."))
        }
        if !errors.isEmpty {
            completion(.failure(.form(errors)))
            return
        }
        let endpoint = ChangeEmailEndpoint(username: username, currentPassword: currentPassword, email: email)
        networkAccess
            .request(endpoint)
            .sink(receiveCompletion: { result in
                switch result {
                case .finished:
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
