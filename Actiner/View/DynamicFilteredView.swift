//
//  DynamicFilteredView.swift
//  ezitinerary
//
//  Created by Alfredo Junio on 26/04/22.
//

import SwiftUI
import CoreData

struct DynamicFilteredView<Content: View, T>: View where T: NSManagedObject {
    // Core data request
    @FetchRequest var request: FetchedResults<T>
    let content: (T)->Content
    
    
    // Building custom foreach which will give coredata to object View
    init (dateToFilter: Date, @ViewBuilder content: @escaping (T)->Content) {
        
        // Predicate to filter current data tasks
        let calendar = Calendar.current
        
        let today = calendar.startOfDay(for: dateToFilter)
        let tommorow = calendar.date(byAdding: .day, value: 1, to: today)
        
        // Filter key
        let filterKey = "actDate"
        
        // This will fetch activity between today and tommorow which is 24 hours
        let predicate = NSPredicate(format: "\(filterKey) >= %@ AND \(filterKey) < %@", argumentArray: [today, tommorow ?? Date()])
        
        // Initializing request with NSPredict
        _request = FetchRequest(entity: T.entity(), sortDescriptors: [.init(keyPath: \TripActivity.actDate, ascending: true)], predicate: predicate)
        
        self.content = content
    }
    
    
    var body: some View {
        Group {
            if request.isEmpty {
                Text("No activity found!")
                    .font(.system(size: 16))
                    .fontWeight(.light)
                    .offset(y: 100)
            } else {
                ForEach(request, id:\.objectID) {object in
                    self.content(object)
                }
            }
        }
    }
}

struct DynamicDateView<Content: View, T>: View where T: NSManagedObject {
    // Core data request
    @FetchRequest var request: FetchedResults<T>
    let content: (T)->Content
    
    
    // Building custom foreach which will give coredata to object View
    init (@ViewBuilder content: @escaping (T)->Content) {
        
        // Filter key
//        let filterKey = "actDate"
        
        // This will fetch activity between today and tommorow which is 24 hours
//        let predicate = NSPredicate(format: "\(filterKey) >= %@ AND \(filterKey) < %@")
        
        // Initializing request with NSPredict
        _request = FetchRequest(entity: T.entity(), sortDescriptors: [.init(keyPath: \TripActivity.actDate, ascending: true)])
        
        
        
        self.content = content
    }
    
    
    var body: some View {
        Group {
            if request.isEmpty {
                Text("No activity found!")
                    .font(.system(size: 16))
                    .fontWeight(.light)
                    .offset(y: 100)
            } else {
                ForEach(request, id:\.objectID) {object in
                    self.content(object)
                }
            }
        }
    }
}
