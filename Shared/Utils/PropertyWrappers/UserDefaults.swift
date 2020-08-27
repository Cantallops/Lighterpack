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

extension UserDefaults {
    subscript<Key: RawRepresentable, T>(_ key: Key) -> T? where Key.RawValue == String {
        get {
            object(forKey: key.rawValue) as? T
        }
        set {
            set(newValue, forKey: key.rawValue)
        }
    }

    subscript<Key: RawRepresentable, T: RawRepresentable>(_ key: Key) -> T? where Key.RawValue == String {
        get {
            guard let value = object(forKey: key.rawValue) as? T.RawValue else { return nil }
            return T(rawValue: value)
        }
        set {
            set(newValue?.rawValue, forKey: key.rawValue)
        }
    }

    subscript<T>(_ key: String) -> T? {
        get {
            object(forKey: key) as? T
        }
        set {
            set(newValue, forKey: key)
        }
    }
}
