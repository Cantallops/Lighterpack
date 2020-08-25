//
//  LighterPackApp.swift
//  Shared
//
//  Created by acantallops on 2020/08/18.
//

import SwiftUI

@main
struct LighterPackApp: App {

    let context = PersistentContainer.persistentContainer.viewContext
    let syncEngine = SyncEngine()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    syncEngine.run()
                }
                .environment(\.managedObjectContext, context)
        }
    }
}
