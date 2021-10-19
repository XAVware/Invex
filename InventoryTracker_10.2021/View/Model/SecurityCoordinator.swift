//
//  SecurityCoordinator.swift
//  InventoryTracker_10.2021
//
//  Created by Ryan Smetana on 10/18/21.
//

import SwiftUI

class SecurityCoordinator: ObservableObject {
    @Published var passcode: String = ""
    
    
    func setPasscode(to newPasscode: String) {
        passcode = newPasscode
    }
}
