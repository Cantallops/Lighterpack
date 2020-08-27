import Foundation

extension KeyedDecodingContainer {
    public func decodeIntBool(forKey key: KeyedDecodingContainer<K>.Key) throws -> Bool {
        do {
            return (try decode(Int.self, forKey: key)) != 0
        } catch DecodingError.typeMismatch {
            return try decode(Bool.self, forKey: key)
        }
    }
}
