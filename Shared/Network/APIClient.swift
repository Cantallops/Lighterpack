import Foundation

public enum HttpMethod: String {
    case GET
    case POST
}

public protocol Endpoint {
    associatedtype Response: Decodable
    var httpMethod: HttpMethod { get }
    var path: String { get }

    var headers: [String: String] { get }
    var authenticated: Bool { get }
    var params: [String: Any]? { get }
}

public extension Endpoint {
    var httpMethod: HttpMethod { .GET  }
    var headers: [String: String] { [:] }
    var authenticated : Bool { false }
    var params: [String: Any]? { nil }
}
