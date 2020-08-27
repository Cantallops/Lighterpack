import Foundation
import Combine

extension SessionStore {
    func logout() {
        sessionCookie = ""
    }
}
