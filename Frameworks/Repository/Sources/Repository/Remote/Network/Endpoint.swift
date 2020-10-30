import Foundation

public protocol Endpoint {
    associatedtype Response: Decodable
    var httpMethod: HttpMethod { get }
    var path: String { get }

    var headers: [String: String] { get }
    var params: [String: Any]? { get }

    func processNetworkError(_ error: RepositoryError) -> RepositoryError
    func processResponse(response: HTTPURLResponse, data: Data) throws -> Response
}

public extension Endpoint {
    var httpMethod: HttpMethod { .GET  }
    var headers: [String: String] { [:] }
    var params: [String: Any]? { nil }

    func processError(_ error: Error) -> Error {
        guard let networkError = error as? RepositoryError else { return error }
        return processNetworkError(networkError)
    }
    func processNetworkError(_ error: RepositoryError) -> RepositoryError { error }

    func processResponse(response: HTTPURLResponse, data: Data) throws -> Response {
        let value = try JSONDecoder().decode(Response.self, from: data)
        return value
    }
}

extension Endpoint {
    var logString: String {
        "\(httpMethod.rawValue) /\(path)"
    }
}
