import SwiftUI
import os.log

extension Logger {
    private static var subsystem = Bundle.main.bundleIdentifier!

    static let ui = Logger(subsystem: subsystem, category: "UI")
}


public protocol Screen: View {
    associatedtype Content : View
    @ViewBuilder var content: Self.Content { get }
}

public extension Screen {
    var body: some View {
        content
            .onAppear {
                Logger.ui.info("▫️ Screen \(type(of: self)) appeared")
            }
            .onDisappear {
                Logger.ui.info("◾️ Screen \(type(of: self)) disappeared")
            }
    }
}
