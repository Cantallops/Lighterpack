//
//  Price.swift
//  LighterPack
//
//  Created by acantallops on 2020/08/24.
//

import Foundation
extension SignedInteger {
    func formattedPrice(_ currencySymbol: String) -> String {
        Double(self).formattedPrice(currencySymbol)
    }
}

extension Float {
    func formattedPrice(_ currencySymbol: String) -> String {
        Double(self).formattedPrice(currencySymbol)
    }
}

extension Double {
    func formattedPrice(_ currencySymbol: String) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = currencySymbol
        return formatter.string(from: NSNumber(value: self)) ??
            "\(currencySymbol)\(String(format: "%.2f", self))"

    }
}
