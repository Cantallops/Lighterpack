import Foundation
import Combine
import Entities

public protocol RemoteRepository {

    // Get info
    func getInfo(cookie: String) -> AnyPublisher<LighterPackResponse, Error>
    func update(username: String, library: Library, syncToken: Int, cookie: String) -> AnyPublisher<Int, Error>

    // User
    func login(username: String, password: String) -> AnyPublisher<String, Error>
    func logout(username: String) -> AnyPublisher<Void, Error>

    func register(email: String, username: String, password: String) -> AnyPublisher<Void, Error>

    func changeEmail(with email: String, ofUsername username: String, password: String, cookie: String) -> AnyPublisher<Void, Error>
    func forgotPassword(ofUsername username: String) -> AnyPublisher<Void, Error>
    func changePassword(ofUsername username: String, password: String, newPassword: String, cookie: String) -> AnyPublisher<Void, Error>
    func deleteAccount(username: String, password: String, cookie: String) -> AnyPublisher<Void, Error>
}
