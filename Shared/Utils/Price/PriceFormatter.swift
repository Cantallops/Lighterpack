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
        return "\(currencySymbol)\(String(format: "%.2f", self))"
    }
}
