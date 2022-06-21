//
//  BoardingScreen.swift
//  Actiner
//
//  Created by Alfredo Junio on 19/05/22.
//

import SwiftUI

struct BoardingScreen: Identifiable {
    var id = UUID().uuidString
    var image: String
    var title: String
    var description: String
}


// Sample Model Screens...
var boardingScreens: [BoardingScreen] = [
    BoardingScreen(image: "screen1", title: "Traveling Now is So Much Easier", description: "Actiner can assist you in scheduling your itinerary activities"),
    BoardingScreen(image: "screen2", title: "As a Reminder for Each of Your Activities", description: "There are notifications that can help you to do your activities"),
    BoardingScreen(image: "screen3", title: "Determine the Priority of Your Itinerary Activity", description: "Priority in traveling is very important to determine where you are going"),
    BoardingScreen(image: "screen4", title: "You can Make it by Calculating the Budget", description: "Actiner helps you in calculating every expense in your itinerary activities")
]
