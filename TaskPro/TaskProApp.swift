//
//  TaskProApp.swift
//  TaskPro
//
//  Created by Nico Müller on 04.06.23.
//

import SwiftUI

@main
struct TaskProApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
