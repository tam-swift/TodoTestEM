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

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                TodosView()
                    .environmentObject(vm)
                    .preferredColorScheme(.dark)
            }
        }
    }
}
