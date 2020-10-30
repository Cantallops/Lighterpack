import SwiftUI

public struct Field: View {
    private let icon: Icon.Token?
    private let error: String?
    private let textField: TextField<Text>
    private let secureField: SecureField<Text>
    private let secured: Bool

    private var hasError: Bool { !(error?.isEmpty ?? true)}

    public var body: some View {
        VStack(alignment: .leading) {
            HStack {
                if let icon = icon {
                    Icon(icon)
                        .frame(width: 25)
                }
                if secured {
                    secureField
                } else {
                    textField
                }
            }
            if let error = error, !error.isEmpty {
                Text(error)
                    .foregroundColor(.systemRed)
                    .font(.footnote)
            }
        }
    }
}


public extension Field {
    init<S>(_ title: S, text: Binding<String>, icon: Icon.Token? = nil, secured: Bool = false, error: String? = nil, onEditingChanged: @escaping (Bool) -> Void = { _ in }, onCommit: @escaping () -> Void = {}) where S : StringProtocol {
        self.icon = icon
        self.error = error
        self.secured = secured
        self.textField = TextField(title, text: text, onEditingChanged: onEditingChanged, onCommit: onCommit)
        self.secureField = SecureField(title, text: text, onCommit: onCommit)
    }
}
