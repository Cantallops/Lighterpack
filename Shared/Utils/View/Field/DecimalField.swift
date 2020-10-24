import SwiftUI

struct DecimalField: View {

    @Binding var amount: Float
    private var formatter: NumberFormatter

    private var amountProxy: Binding<String> {
        Binding<String>(
            get: {
                formatter.string(from: NSNumber(value: amount)) ?? ""
            },
            set: {
                if let value = formatter.number(from: $0) {
                    self.amount = value.floatValue
                }
            }
        )
    }

    var body: some View {
        TextField("Amount", text: amountProxy)
            .multilineTextAlignment(.trailing)
            .keyboardType(.decimalPad)
    }

    init(
        amount: Binding<Float>,
        formatter: NumberFormatter? = nil
    ) {
        self._amount = amount
        self.formatter = formatter ?? .init()
    }

}
