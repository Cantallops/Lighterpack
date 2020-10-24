import Foundation
import Combine
import SwiftUI

final class SessionStore: ObservableObject, CookieProvider {

    private let userDefaults: UserDefaults
    var cancellables: Set<AnyCancellable> = .init()
    let networkAccess: LighterPackAccess

    @AppStorage(.username) var username
    @AppStorage(.syncToken) var syncToken
    @AppStorage(.backendVersion) var version
    @AppStorage(.sessionCookie) var cookie

    init(
        networkAccess: LighterPackAccess,
        userDefaults: UserDefaults = .standard
    ) {
        self.networkAccess = networkAccess
        self.userDefaults = userDefaults

        _username = AppStorage(.username, store: userDefaults)
        _syncToken = AppStorage(.syncToken, store: userDefaults)
        _version = AppStorage(.backendVersion, store: userDefaults)
        _cookie = AppStorage(.sessionCookie, store: userDefaults)

        networkAccess.cookieProvider = self
    }

    var isLoggedIn: Bool { return !cookie.isEmpty }
}

public struct StorageKey<Value> {
    public var key: String
    public var defaultValue: Value

    public init(key: String, defaultValue: Value) {
        self.key = key
        self.defaultValue = defaultValue
    }
}

extension StorageKey {
    static var username: StorageKey<String> { .init(key: #function, defaultValue: "") }
    static var sessionCookie: StorageKey<String> { .init(key: #function, defaultValue: "") }
    static var backendVersion: StorageKey<String> { .init(key: #function, defaultValue: "0") }
    static var syncToken: StorageKey<Int?> { .init(key: #function, defaultValue: nil) }

}
