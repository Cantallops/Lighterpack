import Foundation
import Entities
import Combine

public class AppRemoteRepository: RemoteRepository {

    let networkAccess: LighterPackAccess

    enum MockError: Error {
        case mock
    }

    public init(
        access: LighterPackAccess = .init()
    ) {
        self.networkAccess = access
    }

    public func getInfo(cookie: String) -> AnyPublisher<LighterPackResponse, Error> {
        networkAccess
            .request(RetrieveInfoEndpoint(cookie: cookie))
            .receive(on: DispatchQueue.global(qos: .userInteractive))
            .eraseToAnyPublisher()
    }

    public func update(username: String, library: Library, syncToken: Int, cookie: String) -> AnyPublisher<Int, Error> {
        do {
            let data = try library.asJSONData()

            // TODO send library
            return networkAccess
                .request(SaveEndpoint(username: username, data: data, syncToken: syncToken, cookie: cookie))
                .map(\.syncToken)
                .receive(on: DispatchQueue.global(qos: .userInteractive))
                .eraseToAnyPublisher()
        } catch {
            return Future { promise in
                promise(.failure(RepositoryError(codeStatus: 0, error: .unknown)))
            }
            .receive(on: DispatchQueue.global(qos: .userInteractive))
            .eraseToAnyPublisher()
        }
    }


    public func login(username: String, password: String) -> AnyPublisher<String, Error> {
        networkAccess
            .request(SignInEndpoint(username: username, password: password))
            .receive(on: DispatchQueue.global(qos: .userInteractive))
            .eraseToAnyPublisher()
    }

    public func logout(username: String) -> AnyPublisher<Void, Error> {
        Future { promise in promise(.success(()))}.eraseToAnyPublisher()
    }

    public func register(email: String, username: String, password: String) -> AnyPublisher<Void, Error> {
        networkAccess
            .request(RegisterEndpoint(email: email, username: username, password: password))
            .map { _ in () }
            .receive(on: DispatchQueue.global(qos: .userInteractive))
            .eraseToAnyPublisher()
    }

    public func changeEmail(with email: String, ofUsername username: String, password: String, cookie: String) -> AnyPublisher<Void, Error> {
        let endpoint = ChangeEmailEndpoint(username: username, currentPassword: password, email: email, cookie: cookie)
        return networkAccess
            .request(endpoint)
            .map { _ in () }
            .receive(on: DispatchQueue.global(qos: .userInteractive))
            .eraseToAnyPublisher()
    }

    public func forgotPassword(ofUsername username: String) -> AnyPublisher<Void, Error> {
        networkAccess
            .request(ForgotPasswordEndpoint(username: username))
            .map { _ in () }
            .receive(on: DispatchQueue.global(qos: .userInteractive))
            .eraseToAnyPublisher()
    }

    public func changePassword(ofUsername username: String, password: String, newPassword: String, cookie: String) -> AnyPublisher<Void, Error> {
        networkAccess
            .request(ChangePasswordEndpoint(username: username, currentPassword: password, newPassword: newPassword, cookie: cookie))
            .map { _ in () }
            .receive(on: DispatchQueue.global(qos: .userInteractive))
            .eraseToAnyPublisher()
    }

    public func deleteAccount(username: String, password: String, cookie: String) -> AnyPublisher<Void, Error> {
        networkAccess
            .request(DeleteAccountEndpoint(username: username, password: password, cookie: cookie))
            .map { _ in () }
            .receive(on: DispatchQueue.global(qos: .userInteractive))
            .eraseToAnyPublisher()
    }
}

private extension Encodable {
  func asJSONData() throws -> String {
    let encoder = JSONEncoder()
    encoder.outputFormatting = .prettyPrinted
    encoder.dateEncodingStrategy = .iso8601
    let jsonData = try encoder.encode(self)
    guard let jsonString = String(data: jsonData, encoding: .utf8) else {
        throw NSError()
    }
    return jsonString
  }
}

