//
//  TestEMApp.swift
//  TestEM
//
//  Created by Tamerlan Swift on 28.10.2025.
//

import SwiftUI

@main
struct TestEMApp: App {
    @StateObject var vm = TodosViewModel()
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                TodosView()
                    .environmentObject(vm)
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
                    .preferredColorScheme(.dark)
            }
        }
    }
}
