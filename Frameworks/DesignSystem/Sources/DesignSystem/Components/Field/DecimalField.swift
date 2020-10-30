import SwiftUI

public struct DecimalField: View {

    @Binding var amount: Float
    private let formatter: NumberFormatter
    private let placeholder: String

    private var amountProxy: Binding<NSNumber> {
        .init(
            get: {
                NSNumber(value: amount)
            },
            set: {
                amount = Float(truncating: $0)
            }
        )
    }

    public var body: some View {
        DecimalTextField(placeholder, value: amountProxy, formatter: formatter)
    }

    public init(
        amount: Binding<Float>,
        placeholder: String = "Amount",
        formatter: NumberFormatter? = nil
    ) {
        self._amount = amount
        self.placeholder = placeholder
        self.formatter = formatter ?? .init()
    }

}

struct DecimalTextField: UIViewRepresentable {
    private var placeholder: String
    @Binding var value: NSNumber
    private var formatter: NumberFormatter

    init(_ placeholder: String,
         value: Binding<NSNumber>,
         formatter: NumberFormatter ) {
        self.placeholder = placeholder
        self._value = value
        self.formatter = formatter
    }

    func makeUIView(context: Context) -> UITextField {
        let textfield = UITextField()
        textfield.keyboardType = .decimalPad
        textfield.delegate = context.coordinator
        textfield.placeholder = placeholder
        textfield.text = formatter.string(for: value) ?? placeholder
        textfield.textAlignment = .right

        return textfield
    }

    func updateUIView(_ uiView: UITextField, context: Context) {
        if !uiView.isEditing {
            uiView.text = formatter.string(for: value) ?? placeholder
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: DecimalTextField

        init(_ textField: DecimalTextField) {
            self.parent = textField
        }

        func textField(
            _ textField: UITextField,
            shouldChangeCharactersIn range: NSRange,
            replacementString string: String
        ) -> Bool {
            let isNumber = CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: string))
            let withDecimal = string == self.parent.formatter.decimalSeparator && textField.text?.contains(string) == false

            if isNumber || withDecimal, let currentValue = textField.text as NSString? {
                let proposedValue = currentValue.replacingCharacters(in: range, with: string) as String
                let number = self.parent.formatter.number(from: proposedValue) ?? 0.0
                self.parent.value = number
            }

            return isNumber || withDecimal
        }

        func textFieldDidEndEditing(
            _ textField: UITextField,
            reason: UITextField.DidEndEditingReason
        ) {
            textField.text = self.parent.formatter.string(for: self.parent.value)
        }

    }
}
