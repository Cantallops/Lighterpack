import Foundation

enum StarColor: Int, CaseIterable, Codable {
    case none = 0
    case yellow
    case red
    case green

    var title: String {
        switch self {
        case .none: return "None"
        case .yellow: return "Yellow"
        case .red: return "Red"
        case .green: return "Green"
        }
    }
}
