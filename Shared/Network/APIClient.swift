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

    func processNetworkError(_ error: NetworkError) -> NetworkError
}

public extension Endpoint {
    var httpMethod: HttpMethod { .GET  }
    var headers: [String: String] { [:] }
    var authenticated : Bool { false }
    var params: [String: Any]? { nil }

    func processError(_ error: Error) -> Error {
        guard let networkError = error as? NetworkError else { return error }
        return processNetworkError(networkError)
    }
    func processNetworkError(_ error: NetworkError) -> NetworkError { error }
}

public struct ErrorMessage: Codable {
    let message: String
}

public struct NetworkError: Error {
    var codeStatus: HTTPStatusCode
    var errorMessage: ErrorMessage?
}

extension NetworkError: LocalizedError {
    public var errorDescription: String? {
        return errorMessage?.message ?? "Unknown error please, try again"
    }

    public var failureReason: String? { nil }
    public var recoverySuggestion: String? { nil }
    public var helpAnchor: String? { nil }
}
