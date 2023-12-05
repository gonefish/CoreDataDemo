//
//  CoreDataDemoApp.swift
//  CoreDataDemo
//

import SwiftUI

@main
struct CoreDataDemoApp: App {
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, MyPersistenceController.default.container.viewContext)
        }
    }
}
