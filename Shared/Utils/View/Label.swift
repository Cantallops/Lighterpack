import SwiftUI

extension Label where Title == Text, Icon == LighterPack.Icon {

    internal init(_ title: String, icon: LighterPack.Icon.Token) {
        self.init(title: {
            Text(title)
        }, icon: {
            Icon(icon)
        })
    }

}
