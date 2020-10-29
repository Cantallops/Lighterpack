import Foundation

public struct RepositoryError: Error {
    var codeStatus: Int
    var error: ErrorType

    public enum ErrorType: Error {
        case message(String)
        case messages([ErrorMessage])
        case form([FormErrorEntry])
        case unauthenticated(String)
        case unknown
    }
}

public extension RepositoryError {
    static func itemNotFound(_ id: Int) -> Self {
        .init(codeStatus: 404, error: .message("Item not found"))
    }
    static func categoryNotFound(_ id: Int) -> Self {
        .init(codeStatus: 404, error: .message("Category not found"))
    }
    static func listNotFound(_ id: Int) -> Self {
        .init(codeStatus: 404, error: .message("List not found"))
    }
}

extension RepositoryError: LocalizedError {
    public var errorDescription: String? {
        return error.localizedDescription
    }
}


extension RepositoryError.ErrorType: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .messages(let messages):
            return messages.map { $0.message }.joined(separator: "\n")
        case .form(let errors):
            return errors.map { $0.message }.joined(separator: "\n")
        case .unknown:
            return "Unknown error please, try again"
        case .unauthenticated(let message):
            return message
        case .message(let message):
            return message
        }
    }
}
