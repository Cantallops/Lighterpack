import Foundation
import Entities
import Combine

public protocol LocalRepository {
    var username: String { get set }
    var library: Library { get set }
    var originalLibrary: Library? { get set }
    var syncToken: Int { get set }

    var cookie: String? { get set }

    func recompute()
}

public extension LocalRepository {
    var hasChanges: Bool {
        library != originalLibrary
    }

    mutating func logout() {
        library = .placeholder
        originalLibrary = nil
        syncToken = 0
        cookie = nil
    }
}
