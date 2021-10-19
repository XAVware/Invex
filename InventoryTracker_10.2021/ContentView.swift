//
//  ContentView.swift
//  InventoryTracker_10.2021
//
//  Created by Ryan Smetana on 10/14/21.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var securityCoordinator: SecurityCoordinator = SecurityCoordinator()
    
    var body: some View {
        if securityCoordinator.passcode == "" {
            OnboardingView(securityCoordinator: self.securityCoordinator)
        } else {
            RegisterView()
        }
        
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
