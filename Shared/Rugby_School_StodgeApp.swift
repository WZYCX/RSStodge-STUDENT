//
//  Rugby_School_StodgeApp.swift
//  Shared
//
//  Created by William Chen on 02/08/2022.
//

import SwiftUI

@main
struct Rugby_School_StodgeApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
