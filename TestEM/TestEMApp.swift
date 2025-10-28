//
//  TestEMApp.swift
//  TestEM
//
//  Created by Tamerlan Swift on 28.10.2025.
//

import SwiftUI

@main
struct TestEMApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
