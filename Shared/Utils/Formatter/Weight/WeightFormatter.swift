import Foundation
import Entities

extension SignedInteger {
    func formattedWeight(_ weightUnit: WeightUnit, showUnit: Bool = true) -> String {
        Double(self).formattedWeight(weightUnit, showUnit: showUnit)
    }
}

extension Float {
    func formattedWeight(_ weightUnit: WeightUnit, showUnit: Bool = true) -> String {
        Double(self).formattedWeight(weightUnit, showUnit: showUnit)
    }

    func convertedWeight(_ weightUnit: WeightUnit) -> Self {
        Float(Double(self).convertedWeight(weightUnit))
    }

    func rawWeight(_ weightUnit: WeightUnit) -> Self {
        Float(Double(self).rawWeight(weightUnit))
    }
}

extension Double {
    func formattedWeight(_ weightUnit: WeightUnit, showUnit: Bool = true) -> String {
        let value = convertedWeight(weightUnit)
        if showUnit {
            return "\(value)\(weightUnit.rawValue)"
        }
        return "\(value)"
    }


    func convertedWeight(_ weightUnit: WeightUnit) -> Self {
        var div: Double = 1
        switch weightUnit {
        case .g: div = 1000.0
        case .kg: div = 1000000.0
        case .lb: div = 453592.0
        case .oz: div = 28349.5
        }

        return (100.0 * self / div).rounded() / 100
    }

    func rawWeight(_ weightUnit: WeightUnit) -> Self {
        var div: Double = 1
        switch weightUnit {
        case .g: div = 1000.0
        case .kg: div = 1000000.0
        case .lb: div = 453592.0
        case .oz: div = 28349.5
        }

        return self * div
    }
}
