import SwiftUI

@main
struct LighterPackApp: App {
    @Environment(\.scenePhase) var scenePhase
    @StateObject var appStore: AppStore = .init()

    var body: some Scene {
        WindowGroup {
            HomeScreen()
                .receiveVisualFeedback()
                .onAppear {
                    appStore.fetch()
                }
                .environmentObject(appStore.settingsStore)
                .environmentObject(appStore.sessionStore)
                .environmentObject(appStore.libraryStore)
        }
    }
}
