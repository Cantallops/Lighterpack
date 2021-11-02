import SwiftUI

public extension Color {
    static var systemRed: Color { .init(.systemRed) }
    static var systemGreen: Color { .init(.systemGreen) }
    static var systemBlue: Color { .init(.systemBlue) }
    static var systemOrange: Color { .init(.systemOrange) }
    static var systemYellow: Color { .init(.systemYellow) }
    static var systemPink: Color { .init(.systemPink) }
    static var systemPurple: Color { .init(.systemPurple) }
    static var systemTeal: Color { .init(.systemTeal) }
    static var systemIndigo: Color { .init(.systemIndigo) }
    static var systemGray: Color { .init(.systemGray) }
    static var systemGray2: Color { .init(.systemGray2) }
    static var systemGray3: Color { .init(.systemGray3) }
    static var systemGray4: Color { .init(.systemGray4) }
    static var systemGray5: Color { .init(.systemGray5) }
    static var systemGray6: Color { .init(.systemGray6) }
    static var label: Color { .init(.label) }
    static var secondaryLabel: Color { .init(.secondaryLabel) }
    static var tertiaryLabel: Color { .init(.tertiaryLabel) }
    static var quaternaryLabel: Color { .init(.quaternaryLabel) }
    static var link: Color { .init(.link) }
    static var placeholderText: Color { .init(.placeholderText) }
    static var separator: Color { .init(.separator) }
    static var opaqueSeparator: Color { .init(.opaqueSeparator) }
    static var systemBackground: Color { .init(.systemBackground) }
    static var secondarySystemBackground: Color { .init(.secondarySystemBackground) }
    static var tertiarySystemBackground: Color { .init(.tertiarySystemBackground) }
    static var systemGroupedBackground: Color { .init(.systemGroupedBackground) }
    static var secondarySystemGroupedBackground: Color { .init(.secondarySystemGroupedBackground) }
    static var tertiarySystemGroupedBackground: Color { .init(.tertiarySystemGroupedBackground) }
    static var systemFill: Color { .init(.systemFill) }
    static var secondarySystemFill: Color { .init(.secondarySystemFill) }
    static var tertiarySystemFill: Color { .init(.tertiarySystemFill) }
    static var quaternarySystemFill: Color { .init(.quaternarySystemFill) }
}

public extension View {

    @inlinable func backgroundColor(_ color: Color?) -> some View {
        self.background(color)
    }

    @inlinable func listRowBackgroundColor(_ color: Color?) -> some View {
        self.listRowBackground(color)
    }
}
