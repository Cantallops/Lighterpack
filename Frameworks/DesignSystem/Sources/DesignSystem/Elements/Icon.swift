import SwiftUI

public struct Icon: View {

    public struct Token {
        private(set) var rawValue: String
        private(set) var originalColor: UIColor?
        private(set) var defaultRenderingMode: Image.TemplateRenderingMode
        var color: Color? {
            guard let color = originalColor else { return nil }
            return .init(color)
        }

        fileprivate init(rawValue: String, originalColor: UIColor? = nil, defaultRenderingMode: Image.TemplateRenderingMode = .template) {
            self.rawValue = rawValue
            self.originalColor = originalColor
            self.defaultRenderingMode = defaultRenderingMode
        }
    }

    var token: Token
    private var renderingMode: RenderingMode

    public enum RenderingMode {
        case original
        case template
        case auto
    }

    public init(_ token: Token, renderingMode: RenderingMode = .auto) {
        self.token = token
        self.renderingMode = renderingMode
    }

    public var body: some View {
        switch renderingMode {
        case .auto:
            if let color = token.color {
                Image(systemName: token.rawValue)
                    .renderingMode(.template)
                    .foregroundColor(color)
            } else {
                Image(systemName: token.rawValue)
                    .renderingMode(token.defaultRenderingMode)
            }
        case .template:
            Image(systemName: token.rawValue)
                .renderingMode(.template)
        case .original:
            if let color = token.color {
                Image(systemName: token.rawValue)
                    .renderingMode(.template)
                    .foregroundColor(color)
            } else {
                Image(systemName: token.rawValue)
                    .renderingMode(.original)
            }
        }
    }

    public func renderingMode(_ renderingMode: RenderingMode) -> Self {
        return .init(token, renderingMode: renderingMode)
    }
}

public extension Icon.Token {
    typealias Token = Icon.Token
    static let gearList = Token(rawValue: "shippingbox", originalColor: .systemOrange)
    static let lists = Token(rawValue: "chart.bar.doc.horizontal.fill")
    static let profile = Token(rawValue: "person.crop.circle.fill", originalColor: .systemIndigo)
    static let accountSettings = Token(rawValue: "gearshape.fill", originalColor: .systemGray)
    static let currency = Token(rawValue: "coloncurrencysign.circle.fill", originalColor: .systemGreen)
    static let images = Token(rawValue: "photo.on.rectangle.angled", originalColor: .systemPurple)
    static let price = Token(rawValue: "tag.fill", originalColor: .systemPink)
    static let worn = Token(rawValue: "figure.walk", originalColor: .systemYellow)
    static let consumable = Token(rawValue: "drop.fill", originalColor: .systemTeal)
    static let listDescription = Token(rawValue: "doc.plaintext.fill", originalColor: .systemOrange)
    static let totalWeightUnit = Token(rawValue: "cart.fill", originalColor: .systemGray)
    static let itemWeightUnit = Token(rawValue: "bag.fill", originalColor: .systemPurple)
    static let help = Token(rawValue: "info.circle.fill", defaultRenderingMode: .original)
    static let signOut = Token(rawValue: "multiply.square.fill", originalColor: .systemRed)
    static let categoryDot = Token(rawValue: "circle.fill")
    static let baseWeight = Token(rawValue: "shippingbox.fill", originalColor: .systemIndigo)
    static let password = Token(rawValue: "lock.fill", originalColor: .systemGray)
    static let confirmPassword = Token(rawValue: "lock.circle.fill", originalColor: .systemGray2)

    static let email = Token(rawValue: "envelope.fill", originalColor: .systemBlue)
    static let questionMark = Token(rawValue: "questionmark")

    static let addCategory = Token(rawValue: "rectangle.badge.plus", defaultRenderingMode: .original)
    static let remove = Token(rawValue: "minus.circle.fill")
    static let delete = Token(rawValue: "trash")
    static let add = Token(rawValue: "plus.circle.fill", originalColor: .systemGreen)
    static let star = Token(rawValue: "star.fill")
    static let link = Token(rawValue: "link", originalColor: .systemBlue)
    static let editList = Token(rawValue: "pencil")
    static let edit = Token(rawValue: "pencil")
    static let share = Token(rawValue: "square.and.arrow.up")
    static let `import` = Token(rawValue: "square.and.arrow.down")

    static let quantity = Token(rawValue: "xmark")
    static let sort = Token(rawValue: "arrow.up.arrow.down")

    static let warning = Token(rawValue: "exclamationmark.triangle.fill")
    static let info = Token(rawValue: "info.circle.fill")
    static let confirmation = Token(rawValue: "checkmark.circle.fill")

    static let close = Token(rawValue: "xmark.circle.fill", originalColor: .tertiaryLabel)
    static let rearrange = Token(rawValue: "rectangle.stack")

    enum Sort {

        public static let `default` = Token(rawValue: "textformat.123")
        public static let weight = Token(rawValue: "cart.fill")
        public static let price = Token(rawValue: "tag.fill")
        public static let name = Token(rawValue: "textformat")

        public static let asc = Token(rawValue: "arrow.up.right")
        public static let desc = Token(rawValue: "arrow.down.right")
    }


}
