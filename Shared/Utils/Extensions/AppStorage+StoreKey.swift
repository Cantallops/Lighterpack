import SwiftUI

public extension AppStorage {
    init(wrappedValue: Value, _ storageKey: StorageKey<Value>, store: UserDefaults? = nil) where Value == Bool {
        self.init(wrappedValue: wrappedValue, storageKey.key, store: store)
    }
    init(_ storageKey: StorageKey<Value>, store: UserDefaults? = nil) where Value == Bool {
        self.init(wrappedValue: storageKey.defaultValue, storageKey.key, store: store)
    }

    init(wrappedValue: Value,_ storageKey: StorageKey<Value>, store: UserDefaults? = nil) where Value == Int {
        self.init(wrappedValue: wrappedValue, storageKey.key, store: store)
    }
    init(_ storageKey: StorageKey<Value>, store: UserDefaults? = nil) where Value == Int {
        self.init(wrappedValue: storageKey.defaultValue, storageKey.key, store: store)
    }

    init(wrappedValue: Value,_ storageKey: StorageKey<Value>, store: UserDefaults? = nil) where Value == Double {
        self.init(wrappedValue: wrappedValue, storageKey.key, store: store)
    }
    init(_ storageKey: StorageKey<Value>, store: UserDefaults? = nil) where Value == Double {
        self.init(wrappedValue: storageKey.defaultValue, storageKey.key, store: store)
    }

    init(wrappedValue: Value,_ storageKey: StorageKey<Value>, store: UserDefaults? = nil) where Value == String {
        self.init(wrappedValue: wrappedValue, storageKey.key, store: store)
    }
    init(_ storageKey: StorageKey<Value>, store: UserDefaults? = nil) where Value == String {
        self.init(wrappedValue: storageKey.defaultValue, storageKey.key, store: store)
    }

    init(wrappedValue: Value,_ storageKey: StorageKey<Value>, store: UserDefaults? = nil) where Value == URL {
        self.init(wrappedValue: wrappedValue, storageKey.key, store: store)
    }
    init(_ storageKey: StorageKey<Value>, store: UserDefaults? = nil) where Value == URL {
        self.init(wrappedValue: storageKey.defaultValue, storageKey.key, store: store)
    }

    init(wrappedValue: Value,_ storageKey: StorageKey<Value>, store: UserDefaults? = nil) where Value == Data {
        self.init(wrappedValue: wrappedValue, storageKey.key, store: store)
    }
    init(_ storageKey: StorageKey<Value>, store: UserDefaults? = nil) where Value == Data {
        self.init(wrappedValue: storageKey.defaultValue, storageKey.key, store: store)
    }

    init(wrappedValue: Value,_ storageKey: StorageKey<Value>, store: UserDefaults? = nil) where Value : RawRepresentable, Value.RawValue == Int {
        self.init(wrappedValue: wrappedValue, storageKey.key, store: store)
    }
    init(_ storageKey: StorageKey<Value>, store: UserDefaults? = nil) where Value : RawRepresentable, Value.RawValue == Int {
        self.init(wrappedValue: storageKey.defaultValue, storageKey.key, store: store)
    }

    init(wrappedValue: Value,_ storageKey: StorageKey<Value>, store: UserDefaults? = nil) where Value : RawRepresentable, Value.RawValue == String {
        self.init(wrappedValue: wrappedValue, storageKey.key, store: store)
    }
    init(_ storageKey: StorageKey<Value>, store: UserDefaults? = nil) where Value : RawRepresentable, Value.RawValue == String {
        self.init(wrappedValue: storageKey.defaultValue, storageKey.key, store: store)
    }

}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension AppStorage where Value : ExpressibleByNilLiteral {
    public init(_ storageKey: StorageKey<Value>, store: UserDefaults? = nil) where Value == Bool? {
        self.init(storageKey.key, store: store)
    }
    public init(_ storageKey: StorageKey<Value>, store: UserDefaults? = nil) where Value == Int? {
        self.init(storageKey.key, store: store)
    }
    public init(_ storageKey: StorageKey<Value>, store: UserDefaults? = nil) where Value == Double? {
        self.init(storageKey.key, store: store)
    }
    public init(_ storageKey: StorageKey<Value>, store: UserDefaults? = nil) where Value == String? {
        self.init(storageKey.key, store: store)
    }
    public init(_ storageKey: StorageKey<Value>, store: UserDefaults? = nil) where Value == URL? {
        self.init(storageKey.key, store: store)
    }
    public init(_ storageKey: StorageKey<Value>, store: UserDefaults? = nil) where Value == Data? {
        self.init(storageKey.key, store: store)
    }
}
