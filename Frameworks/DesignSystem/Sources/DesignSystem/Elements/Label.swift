import SwiftUI

public extension Label where Title == Text, Icon == DesignSystem.Icon {

    init(_ title: String, icon: DesignSystem.Icon.Token) {
        self.init(title: {
            Text(title)
        }, icon: {
            Icon(icon)
        })
    }

}
