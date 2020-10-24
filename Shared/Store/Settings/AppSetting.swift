import SwiftUI

public struct AppSettingKey<Value> {
    public var key: String
    public var defaultValue: Value

    public init(key: String, defaultValue: Value) {
        self.key = key
        self.defaultValue = defaultValue
    }
}

@frozen @propertyWrapper public struct AppSetting<Value>: DynamicProperty {

    @ObservedObject private var storage: Storage<Value>
    private let saveValue: (Value) -> Void

    private init(value: Value, store: UserDefaults, key: String, transform: @escaping (Any?) -> Value?, saveValue: @escaping (Value) -> Void) {
        storage = Storage(value: value, store: store, key: key, transform: transform)
        self.saveValue = saveValue
    }

    public var wrappedValue: Value {
        get {
            storage.value
        }
        nonmutating set {
            saveValue(newValue)
            storage.value = newValue
        }
    }

    public var projectedValue: Binding<Value> {
        Binding(
            get: { self.wrappedValue },
            set: { self.wrappedValue = $0 }
        )
    }
}

private class Storage<Value>: NSObject, ObservableObject {
    @Published var value: Value
    private let defaultValue: Value
    private let store: UserDefaults
    private let keyPath: String
    private let transform: (Any?) -> Value?

    init(
        value: Value,
        store: UserDefaults,
        key: String,
        transform: @escaping (Any?) -> Value?
    ) {
        self.value = value
        self.defaultValue = value
        self.store = store
        self.keyPath = key
        self.transform = transform
        super.init()

        store.addObserver(self, forKeyPath: key, options: [.new], context: nil)
    }

    deinit {
        store.removeObserver(self, forKeyPath: keyPath)
    }

    override func observeValue(
        forKeyPath keyPath: String?,
        of object: Any?,
        change: [NSKeyValueChangeKey : Any]?,
        context: UnsafeMutableRawPointer?
    ) {
        value = change?[.newKey].flatMap(transform) ?? defaultValue
    }
}

extension AppSetting where Value == Bool {
    public init(_ key: AppSettingKey<Value>, store: UserDefaults? = nil) {
        let store = (store ?? .standard)
        let initialValue = store.value(forKey: key.key) as? Value ?? key.defaultValue
        self.init(value: initialValue, store: store, key: key.key, transform: {
            $0 as? Value
        }, saveValue: { newValue in
            store.setValue(newValue, forKey: key.key)
        })
    }
}

extension AppSetting where Value == Int {
    public init(_ key: AppSettingKey<Value>, store: UserDefaults? = nil) {
        let store = (store ?? .standard)
        let initialValue = store.value(forKey: key.key) as? Value ?? key.defaultValue
        self.init(value: initialValue, store: store, key: key.key, transform: {
            $0 as? Value
        }, saveValue: { newValue in
            store.setValue(newValue, forKey: key.key)
        })
    }
}

extension AppSetting where Value == Double {
    public init(_ key: AppSettingKey<Value>, store: UserDefaults? = nil) {
        let store = (store ?? .standard)
        let initialValue = store.value(forKey: key.key) as? Value ?? key.defaultValue
        self.init(value: initialValue, store: store, key: key.key, transform: {
            $0 as? Value
        }, saveValue: { newValue in
            store.setValue(newValue, forKey: key.key)
        })
    }
}

extension AppSetting where Value == String {
    public init(_ key: AppSettingKey<Value>, store: UserDefaults? = nil) {
        let store = (store ?? .standard)
        let initialValue = store.value(forKey: key.key) as? Value ?? key.defaultValue
        self.init(value: initialValue, store: store, key: key.key, transform: {
            $0 as? Value
        }, saveValue: { newValue in
            store.setValue(newValue, forKey: key.key)
        })
    }
}

extension AppSetting where Value == URL {

    public init(_ key: AppSettingKey<Value>, store: UserDefaults? = nil) {
        let store = (store ?? .standard)
        let initialValue = store.url(forKey: key.key) ?? key.defaultValue
        self.init(value: initialValue, store: store, key: key.key, transform: {
            ($0 as? String).flatMap(URL.init)
        }, saveValue: { newValue in
            store.set(newValue, forKey: key.key)
        })
    }
}

extension AppSetting where Value == Data {
    public init(_ key: AppSettingKey<Value>, store: UserDefaults? = nil) {
        let store = (store ?? .standard)
        let initialValue = store.value(forKey: key.key) as? Value ?? key.defaultValue
        self.init(value: initialValue, store: store, key: key.key, transform: {
            $0 as? Value
        }, saveValue: { newValue in
            store.setValue(newValue, forKey: key.key)
        })
    }
}

extension AppSetting where Value : RawRepresentable, Value.RawValue == Int {
    public init(_ key: AppSettingKey<Value>, store: UserDefaults? = nil) {
        let store = (store ?? .standard)
        let rawValue = store.value(forKey: key.key) as? Int
        let initialValue = rawValue.flatMap(Value.init) ?? key.defaultValue
        self.init(value: initialValue, store: store, key: key.key, transform: {
            ($0 as? Int).flatMap(Value.init)
        }, saveValue: { newValue in
            store.setValue(newValue.rawValue, forKey: key.key)
        })
    }
}

extension AppSetting where Value : RawRepresentable, Value.RawValue == String {
    public init(_ key: AppSettingKey<Value>, store: UserDefaults? = nil) {
        let store = (store ?? .standard)
        let rawValue = store.value(forKey: key.key) as? String
        let initialValue = rawValue.flatMap(Value.init) ?? key.defaultValue
        self.init(value: initialValue, store: store, key: key.key, transform: {
            ($0 as? String).flatMap(Value.init)
        }, saveValue: { newValue in
            store.setValue(newValue.rawValue, forKey: key.key)
        })
    }
}
