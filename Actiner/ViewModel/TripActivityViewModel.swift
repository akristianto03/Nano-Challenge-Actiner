//
//  ActivityViewModel.swift
//  ezitinerary
//
//  Created by Alfredo Junio on 25/04/22.
//

import SwiftUI
import CoreData

class TripActivityViewModel: ObservableObject {
    
    // Current week days
    @Published var currentWeek: [Date] = []
    
    // Current activity
    @Published var currentActDate: [Date] = []
    
    // Current day
    @Published var currentDay: Date = Date()
    
    // Filtering Today Activities
    @Published var filteredAct: [TripActivity]?
    
    // New Activity
    @Published var addNewActivity: Bool = false
    
    // Edit Data
    @Published var editActivity: TripActivity?
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.actDate, order: .reverse)]) var tripAct:FetchedResults<TripActivity>
    
    // Initializing
    init() {
        print("current time", CFAbsoluteTimeGetCurrent())
        fetchCurrentWeek()
    }
    
    func fetchCurrentWeek() {
        let today = Date()
        let calendar = Calendar.current
        
        let week = calendar.dateInterval(of: .weekOfMonth, for: today)
        
        guard let firstWeekDay = week?.start else{
            return
        }
        
        (1...7).forEach {day in
            if let weekday = calendar.date(byAdding: .day, value: day, to: firstWeekDay) {
                currentWeek.append(weekday)
            }
        }
    }
    
    
    // Extracting Date
    func extractDate(date: Date, format: String) -> String {
        let formatter = DateFormatter()
        
        formatter.dateFormat = format
        
        return formatter.string(from: date)
    }
    
    // Checking if current date is today
    func isToday(date: Date)->Bool {
        let calendar = Calendar.current
        return calendar.isDate(currentDay, inSameDayAs: date)
    }
    
    // Checking if currentHour is Activity hour
    func isCurrentHour(date: Date)->Bool {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let currentHour = calendar.component(.hour, from: Date())
        
        let isToday = calendar.isDateInToday(date)
        
        return (hour == currentHour && isToday)
    }
}
