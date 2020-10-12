import Foundation
import Combine

final class SessionStore: ObservableObject {

    private let userDefaults: UserDefaults

    @Published var username: String {
        didSet {
            userDefaults[SettingKey.username] = username
        }
    }
    @Published var version: String {
        didSet {
            userDefaults[SettingKey.backendVersion] = version
        }
    }
    @Published var sessionCookie: String {
        didSet {
            userDefaults[SettingKey.sessionCookie] = sessionCookie
        }
    }
    @Published var syncToken: Int {
        didSet {
            userDefaults[SettingKey.syncToken] = syncToken
        }
    }

    var cancellables: Set<AnyCancellable> = .init()

    var isLoggedIn: Bool {
        !sessionCookie.isEmpty
    }

    let networkAccess: LighterPackAccess

    init(
        networkAccess: LighterPackAccess,
        userDefaults: UserDefaults = .standard
    ) {
        self.networkAccess = networkAccess
        self.userDefaults = userDefaults
        username = userDefaults[SettingKey.username] ?? ""
        sessionCookie = userDefaults[SettingKey.sessionCookie] ?? ""
        version = userDefaults[SettingKey.backendVersion] ?? "0.3"
        syncToken = userDefaults[SettingKey.syncToken] ?? 0
        networkAccess.cookieProvider = self
    }
}

extension SessionStore: CookieProvider {
    var cookie: String {
        get {
            sessionCookie
        }
        set {
            DispatchQueue.main.async {
                self.sessionCookie = newValue
            }
        }
    }


}
