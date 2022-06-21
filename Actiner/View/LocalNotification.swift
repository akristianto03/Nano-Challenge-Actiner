//
//  LocalNotification.swift
//  ezitinerary
//
//  Created by Alfredo Junio on 18/05/22.
//

import SwiftUI
import UserNotifications

class NotificationManager {
    static let instance = NotificationManager()
    
    func requestAuthorization() {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { (success, error) in
            if let error = error {
                print("ERROR: \(error)")
            } else {
                print("SUCCESS")
            }
        }
    }
    
    func scheduleNotification(title: String, date: Date) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = "This is reminder to do this activity on your trip"
        content.sound = .default
        content.badge = 1
        
        //format the date
        let hourFormat = DateFormatter()
        hourFormat.dateFormat = "h"
        var kHour: Int = Int(hourFormat.string(from: date)) ?? 0
        let hourDate: String = date.formatted(date: .omitted, time: .shortened)
        
        if hourDate.contains("PM") {
            kHour += 12
        }
        
        let minuteFormat = DateFormatter()
        minuteFormat.dateFormat = "m"
        let kMinute: Int = Int(minuteFormat.string(from: date)) ?? 0
        
        let dayFormat = DateFormatter()
        dayFormat.dateFormat = "dd"
        let kDay: Int = Int(dayFormat.string(from: date)) ?? 0
        
        let monthFormat = DateFormatter()
        monthFormat.dateFormat = "M"
        let kMonth: Int = Int(monthFormat.string(from: date)) ?? 0
        
        
        //time
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        print("hour: "+String(kHour))
        print("minute: "+String(kMinute))
        print("day: "+String(kDay))
        print("month: "+String(kMonth))
        
        //calendar
        var dateComponents = DateComponents()
        dateComponents.hour = kHour
        dateComponents.minute = kMinute
        dateComponents.day = kDay
        dateComponents.month = kMonth
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger
        )
        UNUserNotificationCenter.current().add(request)
    }
    
    func cancelNotification() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
}
