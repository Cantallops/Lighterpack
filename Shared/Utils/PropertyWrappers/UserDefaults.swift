import Foundation

@propertyWrapper
struct UserDefault<T> {
    let key: String
    let defaultValue: T
    let userDefaults: UserDefaults

    init(_ key: String, defaultValue: T, userDefaults: UserDefaults? = nil) {
        self.key = key
        self.defaultValue = defaultValue
        self.userDefaults = userDefaults ?? .standard
    }

    var wrappedValue: T {
        get { userDefaults.object(forKey: key) as? T ?? defaultValue }
        nonmutating set { userDefaults.set(newValue, forKey: key) }
    }
}
