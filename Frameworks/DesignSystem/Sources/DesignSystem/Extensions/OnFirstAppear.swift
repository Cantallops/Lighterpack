import SwiftUI

private struct OnFirstAppearView<Content: View>: View {
    @State
    private var isFirstAppear = true
    let content: Content
    let perform: () -> Void

    var body: some View {
        content.onAppear {
            if isFirstAppear {
                perform()
                isFirstAppear = false
            }
        }
    }
}

public extension View {
    func onFirstAppear(perform: @escaping () -> Void) -> some View {
        OnFirstAppearView(content: self, perform: perform)
    }
}
