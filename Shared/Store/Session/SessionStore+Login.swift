import Foundation
import Combine

extension SessionStore {
    func login(
        username: String,
        password: String,
        completion: @escaping (Result<Void, NetworkError.ErrorType>) -> Void
    ) {
        var errors: [FormErrorEntry] = []
        if username.isEmpty {
            errors.append(.init(field: .username, message: "Please enter a username."))
        }
        if password.isEmpty {
            errors.append(.init(field: .password, message: "Please enter a password."))
        }
        if !errors.isEmpty {
            completion(.failure(.form(errors)))
            return
        }
        let endpoint = SignInEndpoint(username: username, password: password)
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
