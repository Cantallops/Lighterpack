import Foundation
import Combine
import Entities

public protocol RemoteRepository {

    // Get info
    func getInfo() -> AnyPublisher<LighterPackResponse, Error>
    func update(library: Library) -> AnyPublisher<LighterPackResponse, Error>

    // User
    func login(username: String, password: String) -> AnyPublisher<Void, Error>
    func logout(username: String) -> AnyPublisher<Void, Error>

    func register(email: String, username: String, password: String) -> AnyPublisher<Void, Error>

    func changeEmail(with email: String, ofUsername usernam: String, password: String) -> AnyPublisher<Void, Error>
    func forgotPassword(ofUsername username: String) -> AnyPublisher<Void, Error>
    func changePassword(ofUsername username: String, password: String, newPassword: String) -> AnyPublisher<Void, Error>
    func deleteAccount(username: String, password: String) -> AnyPublisher<Void, Error>
}
