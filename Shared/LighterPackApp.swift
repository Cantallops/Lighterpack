//
//  LighterPackApp.swift
//  Shared
//
//  Created by acantallops on 2020/08/18.
//

import SwiftUI

@main
struct LighterPackApp: App {
    @Environment(\.scenePhase) var scenePhase
    @StateObject var appStore: AppStore = .init()

    var body: some Scene {
        WindowGroup {
            ContentView()
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
