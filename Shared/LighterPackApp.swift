import SwiftUI
import Repository

@main
struct LighterPackApp: App {
    @Environment(\.scenePhase) var scenePhase
    @StateObject var store: Repository = .init()

    var body: some Scene {
        WindowGroup {
            HomeScreen()
                .receiveVisualFeedback()
                .onAppear {
                    store.setUp()
                }
                .environmentObject(store)
        }
    }
}
