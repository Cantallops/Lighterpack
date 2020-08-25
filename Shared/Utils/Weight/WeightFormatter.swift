import Foundation

extension SignedInteger {
    func formattedWeight(_ weightUnit: WeigthUnit) -> String {
        Double(self).formattedWeight(weightUnit)
    }
}

extension Float {
    func formattedWeight(_ weightUnit: WeigthUnit) -> String {
        Double(self).formattedWeight(weightUnit)
    }
}

extension Double {
    func formattedWeight(_ weightUnit: WeigthUnit) -> String {
        var div: Double = 1
        switch weightUnit {
        case .g: div = 1000.0
        case .kg: div = 1000000.0
        case .lb: div = 453592.0
        case .oz: div = 28349.5
        }

        let value = (100.0 * self / div).rounded() / 100
        return "\(value)\(weightUnit.rawValue)"
    }
}
