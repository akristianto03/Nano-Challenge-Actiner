//
//  ezitineraryApp.swift
//  ezitinerary
//
//  Created by Alfredo Junio on 25/04/22.
//

import SwiftUI

@main
struct ezitineraryApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
