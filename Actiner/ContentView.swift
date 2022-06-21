//
//  ContentView.swift
//  ezitinerary
//
//  Created by Alfredo Junio on 25/04/22.
//

import SwiftUI

struct ContentView: View {
    
    // Dark/Light Mode
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
//        Home(calendar: Calendar(identifier: .gregorian))
        OnBoarding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
