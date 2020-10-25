import Foundation
import Combine

extension SessionStore {
    func forgotPassword(
        username: String,
        completion: @escaping (Result<String, NetworkError.ErrorType>) -> Void
    ) {
        let endpoint = ForgotPasswordEndpoint(username: username)
        networkAccess.request(endpoint).sink(receiveCompletion: { result in
            switch result {
            case .finished: completion(.success("An email has been sent to the address associated with your account."))
                self.username = username
            case .failure(let error):
                guard let networkError = error as? NetworkError else {
                    completion(.failure(.unknown))
                    return
                }
                completion(.failure(networkError.error))
            }
        }, receiveValue: { _ in })
        .store(in: &cancellables)
    }

    func forgotUsername(
        email: String,
        completion: @escaping (Result<String, NetworkError.ErrorType>) -> Void
    ) {
        let endpoint = ForgotUsernameEndpoint(email: email)
        networkAccess.request(endpoint).sink(receiveCompletion: { result in
            switch result {
            case .finished: completion(.success("An email has been sent to the address associated with your account."))
            case .failure(let error):
                guard let networkError = error as? NetworkError else {
                    completion(.failure(.unknown))
                    return
                }
                completion(.failure(networkError.error))
            }
        }, receiveValue: { _ in })
        .store(in: &cancellables)
    }
}
