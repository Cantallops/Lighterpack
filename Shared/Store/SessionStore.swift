import Foundation
import Combine

final class SessionStore: ObservableObject {
    let objectWillChange = PassthroughSubject<Void, Never>()

    @UserDefault(.username, defaultValue: "") var username: String
    @UserDefault(.backendVersion, defaultValue: "0.3") var version: String
    @UserDefault(.sessionCookie, defaultValue: "") private(set) var sessionCookie: String
    @UserDefault(.syncToken, defaultValue: 0) var syncToken: Int

    private var didChangeCancellable: AnyCancellable?
    private var cancellables: Set<AnyCancellable> = .init()

    var isLoggedIn: Bool {
        !sessionCookie.isEmpty
    }

    var networkAccess: LighterPackAccess = .init()

    init() {
        didChangeCancellable = NotificationCenter.default
            .publisher(for: UserDefaults.didChangeNotification)
            .map { _ in () }
            .receive(on: DispatchQueue.main)
            .subscribe(objectWillChange)
    }
}

extension SessionStore {
    func login(
        username: String,
        password: String,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        let endpoint = SignInEndpoint(username: username, password: password)
        networkAccess
            .request(endpoint)
            .sink(receiveCompletion: { result in
                switch result {
                case .finished: completion(.success(()))
                case .failure(let error): completion(.failure(error))
                }
            }, receiveValue: { _ in }
            ).store(in: &cancellables)
    }
}

extension SessionStore {
    func logout() {
        sessionCookie = ""
    }
}

extension SessionStore {
    func forgotPassword(
        username: String,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        let endpoint = ForgotPasswordEndpoint(username: username)
        networkAccess.request(endpoint).sink(receiveCompletion: { result in
            switch result {
            case .finished: completion(.success("An email has been sent to the address associated with your account."))
                self.username = username
            case .failure(let error): completion(.failure(error))
            }
        }, receiveValue: { _ in })
        .store(in: &cancellables)
    }

    func forgotUsername(
        email: String,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        let endpoint = ForgotUsernameEndpoint(email: email)
        networkAccess.request(endpoint).sink(receiveCompletion: { result in
            switch result {
            case .finished: completion(.success("An email has been sent to the address associated with your account."))
            case .failure(let error): completion(.failure(error))
            }
        }, receiveValue: { _ in })
        .store(in: &cancellables)
    }
}
