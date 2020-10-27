import Foundation
import Repository

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



public struct NetworkError: Error {
    var codeStatus: HTTPStatusCode
    var error: ErrorType

    enum ErrorType: Error {
        case message(String)
        case messages([ErrorMessage])
        case form([FormErrorEntry])
        case unknown
    }
}

extension NetworkError: LocalizedError {
    public var errorDescription: String? {
        return error.localizedDescription
    }
}


extension NetworkError.ErrorType: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .messages(let messages):
            return messages.map { $0.message }.joined(separator: "\n")
        case .form(let errors):
            return errors.map { $0.message }.joined(separator: "\n")
        case .unknown:
            return "Unknown error please, try again"
        case .message(let message):
            return message
        }
    }
}
