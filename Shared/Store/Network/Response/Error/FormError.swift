import Foundation

public struct ErrorMessage: Codable {
    let message: String
}

struct ErrorMessages: Codable {
    let errors: [ErrorMessage]
}

struct FormErrors: Codable {
    let errors: [FormErrorEntry]
}

struct FormErrorEntry: Codable {
    let field: FormField
    let message: String
}

enum FormField: String, Codable {
    case username
    case email
    case password
    case passwordConfirmation
    case currentPassword
    case newPassword
    case confirmationText
}

extension Array where Element == FormErrorEntry {
    func of(_ field: FormField) -> Element? {
        first(where: { $0.field == field })
    }
}
