import Foundation
import Combine

extension SessionStore {
    func deleteAccount(
        username: String,
        currentPassword: String,
        confirmationText: String,
        completion: @escaping (Result<Void, NetworkError.ErrorType>) -> Void
    ) {
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
            completion(.failure(.form(errors)))
            return
        }
        let endpoint = DeleteAccountEndpoint(username: username, password: currentPassword)
        networkAccess
            .request(endpoint)
            .sink(receiveCompletion: { result in
                switch result {
                case .finished:
                    completion(.success(()))
                    self.logout()
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
