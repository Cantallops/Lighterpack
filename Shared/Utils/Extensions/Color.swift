import SwiftUI
import Entities

extension Color {
    public init?(hex: String) {
        guard let uiColor = UIColor(hex: hex) else { return nil }
        self.init(uiColor)
    }

    public init?(_ color: CategoryColor?) {
        guard let color = color else { return nil }
        self.init(UIColor(
                    red: CGFloat(color.r)/255,
                    green: CGFloat(color.g)/255,
                    blue: CGFloat(color.b)/255,
                    alpha: 1)
        )
    }
}

extension Color {
    public func lighter(by amount: CGFloat = 0.2) -> Self {
        .init(UIColor(self).lighter(by: amount))
    }

    public func darker(by amount: CGFloat = 0.2) -> Self {
        .init(UIColor(self).darker(by: amount))
    }

    public func variant(by amount: CGFloat = 0.2) -> Self {
        .init(UIColor(dynamicProvider: { traits -> UIColor in
            switch traits.userInterfaceStyle {
            case .dark: return UIColor(self).darker(by: amount)
            case .light: return UIColor(self).lighter(by: amount)
            case .unspecified: return UIColor(self).lighter(by: amount)
            @unknown default: return UIColor(self).lighter(by: amount)
            }
        }))
    }
}

extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b: CGFloat
        let hexColor = hex.replacingOccurrences(of: "#", with: "")
        if hexColor.count == 6 {
            let scanner = Scanner(string: hexColor)
            var hexNumber: UInt64 = 0

            if scanner.scanHexInt64(&hexNumber) {
                r = CGFloat((hexNumber & 0xff0000) >> 16) / 255
                g = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
                b = CGFloat((hexNumber & 0x0000ff)) / 255

                self.init(red: r, green: g, blue: b, alpha: 1)
                return
            }
        }


        return nil
    }
}

extension UIColor {
    func mix(with color: UIColor, amount: CGFloat) -> Self {
        var red1: CGFloat = 0
        var green1: CGFloat = 0
        var blue1: CGFloat = 0
        var alpha1: CGFloat = 0

        var red2: CGFloat = 0
        var green2: CGFloat = 0
        var blue2: CGFloat = 0
        var alpha2: CGFloat = 0

        getRed(&red1, green: &green1, blue: &blue1, alpha: &alpha1)
        color.getRed(&red2, green: &green2, blue: &blue2, alpha: &alpha2)

        return Self(
            red: red1 * CGFloat(1.0 - amount) + red2 * amount,
            green: green1 * CGFloat(1.0 - amount) + green2 * amount,
            blue: blue1 * CGFloat(1.0 - amount) + blue2 * amount,
            alpha: alpha1
        )
    }

    func lighter(by amount: CGFloat = 0.2) -> Self { mix(with: .white, amount: amount) }
    func darker(by amount: CGFloat = 0.2) -> Self { mix(with: .black, amount: amount) }
}
