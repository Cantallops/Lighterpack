import Foundation

public struct ErrorMessage: Codable {
    public let message: String

    public init(message: String) {
        self.message = message
    }
}

public struct ErrorMessages: Codable {
    public let errors: [ErrorMessage]

    public init(errors: [ErrorMessage]) {
        self.errors = errors
    }
}

public struct FormErrors: Codable {
    public let errors: [FormErrorEntry]

    public init(errors: [FormErrorEntry]) {
        self.errors = errors
    }
}

public struct FormErrorEntry: Codable {
    public let field: FormField
    public let message: String

    public init(
        field: FormField,
        message: String
    ) {
        self.field = field
        self.message = message
    }
}

public enum FormField: String, Codable {
    case username
    case email
    case password
    case passwordConfirmation
    case currentPassword
    case newPassword
    case confirmationText
    case name
    case `description`
}

public extension Array where Element == FormErrorEntry {
    func of(_ field: FormField) -> Element? {
        first(where: { $0.field == field })
    }
}
