//
//  NewActivity.swift
//  ezitinerary
//
//  Created by Alfredo Junio on 26/04/22.
//

import SwiftUI
import Combine

struct NewActivity: View {
    @Environment(\.dismiss) var dismiss
    
    // Dark/Light Mode
    @Environment(\.colorScheme) var colorScheme
    
    // Activity value
    @State var actTitle: String = ""
    @State var actDesc: String = ""
    @State var actBudget: Int = 0
    @State var actBudgetStr: String = ""
    @State var actDate: Date = Date()
    @State var actPrior: String = ""
    @State var actTraveler: Int = 1
    @State var shouldSendNotification: Bool = false
    
    // Core data context
    @Environment(\.managedObjectContext) var context
    
    @EnvironmentObject var tripModel: TripActivityViewModel
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    TextField("Go to beach", text: $actTitle)
                } header: {
                    Text("Activity Title")
                }
                
                Section {
                    TextField("Buy some souvenirs", text: $actDesc)
                } header: {
                    Text("Activity Description")
                }
                let actTypes: [String] = ["Must do's", "Like to do", "Optional"]
                Section {
                    HStack(spacing: 12) {
                        ForEach(actTypes,id: \.self) {type in
                            Text(type)
                                .font(.callout)
                                .padding(.vertical,8)
                                .frame(maxWidth: .infinity)
                                .foregroundStyle(actPrior == type ? .primary : .secondary)
                                .foregroundColor(actPrior == type ? .white : colorScheme == .dark ? .white : .black)
                                .background{
                                    if actPrior == type {
                                        if type == "Must do's" {
                                            Capsule().fill(secondC ?? .black)
                                        } else if type == "Like to do" {
                                            Capsule().fill(blueC ?? .black)
                                        } else {
                                            Capsule().fill(yellowC ?? .black)
                                        }
                                        
                                    } else {
                                        Capsule().strokeBorder(.gray)
                                    }
                                }
                                .contentShape(Capsule())
                                .onTapGesture {
                                    withAnimation{actPrior = type}
                                }
                        }
                    }
                } header: {
                    Text("Priority")
                }
                
                Section {
                    Stepper(String(actTraveler)+" Travelers", value: $actTraveler, in: 1...100)
                    
                } header: {
                    Text("Number of Traveler")
                }
                
                Section {
                    TextField("Money", text: $actBudgetStr)
                        .keyboardType(.numberPad)
                        .onReceive(Just(actBudgetStr)) {newValue in
                            let filtered = newValue.filter { "0123456789".contains($0) }
                            if filtered != newValue {
                                self.actBudgetStr = filtered
                            }
                        }
                } header: {
                    Text("Activity Budget")
                }
                
                if tripModel.editActivity == nil {
                    Section {
                        DatePicker("", selection: $actDate)
                            .datePickerStyle(.graphical)
                            .labelsHidden()
                            .accentColor(primaryC ?? .purple)
                    } header: {
                        Text("Activity Date")
                    }
                }
                
                Section {
                    Toggle("Set Notification", isOn: $shouldSendNotification)
                        .toggleStyle(SwitchToggleStyle(tint: primaryC ?? .purple))
                        .onChange(of: shouldSendNotification) { value in
                            if value == true {
                                NotificationManager.instance.requestAuthorization()
                            }
                        }
                } header: {
                    Text("Notification")
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Add new Activity")
            .navigationBarTitleDisplayMode(.inline)
            // Disable dismiss on swipe
            .interactiveDismissDisabled()
            // Action button
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        if let activities = tripModel.editActivity{
                            activities.actTitle = actTitle
                            activities.actDesc = actDesc
                            activities.actBudget = Int64(actBudgetStr)!
                            activities.actPrior = actPrior
                            activities.actTraveler = Int16(actTraveler)
                        } else {
                            let activities = TripActivity(context: context)
                            activities.actTitle = actTitle
                            activities.actDesc = actDesc
                            activities.actBudget = Int64(actBudgetStr)!
                            activities.actDate = actDate
                            activities.actPrior = actPrior
                            activities.actTraveler = Int16(actTraveler)
                            
                            if shouldSendNotification == true {
                                NotificationManager.instance.scheduleNotification(title: actTitle, date: actDate)
                            }
                        }
                        
                        // Saving
                        try? context.save()
                        
                        // Dismiss content
                        dismiss()
                        
                    }
                    .disabled(actTitle == "" || actDesc == "")
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }.foregroundColor(secondC ?? .red)
                }
            }
            // Loading activity data if from edit
            .onAppear {
                if let activities = tripModel.editActivity{
                    actTitle = activities.actTitle ?? ""
                    actDesc = activities.actDesc ?? ""
                    actBudgetStr = String(activities.actBudget)
                    actPrior = activities.actPrior ?? ""
                    actTraveler = Int(activities.actTraveler)
                }
            }
        }
    }
}
