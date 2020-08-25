//
//  Icon.swift
//  LighterPack
//
//  Created by acantallops on 2020/08/24.
//

import SwiftUI

struct Icon: View {

    struct Token {
        static let gearList = Token(rawValue: "folder.fill")
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

        static let addCategory = Token(rawValue: "rectangle.stack.badge.plus")
        static let remove = Token(rawValue: "minus.circle.fill")
        static let add = Token(rawValue: "plus.circle.fill")
        static let star = Token(rawValue: "star.fill")
        static let link = Token(rawValue: "link", originalColor: .systemBlue)

        static let quantity = Token(rawValue: "xmark")

        private(set) var rawValue: String
        private(set) var originalColor: UIColor?
        private(set) var defaultRenderingMode: Image.TemplateRenderingMode
        var color: Color? {
            guard let color = originalColor else { return nil }
            return .init(color)
        }

        internal init(rawValue: String, originalColor: UIColor? = nil, defaultRenderingMode: Image.TemplateRenderingMode = .template) {
            self.rawValue = rawValue
            self.originalColor = originalColor
            self.defaultRenderingMode = defaultRenderingMode
        }
    }

    var token: Token
    private var renderingMode: RenderingMode

    enum RenderingMode {
        case original
        case template
        case auto
    }

    init(_ token: Token, renderingMode: RenderingMode = .auto) {
        self.token = token
        self.renderingMode = renderingMode
    }

    var body: some View {
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
            Image(systemName: token.rawValue)
                .renderingMode(.original)
        }
    }

    func renderingMode(_ renderingMode: RenderingMode) -> Self {
        return .init(token, renderingMode: renderingMode)
    }
}