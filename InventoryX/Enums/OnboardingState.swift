//
//  OnboardingState.swift
//  InventoryX
//
//  Created by Ryan Smetana on 5/11/24.
//

import Foundation

enum OnboardingState: Int {
    case start = 0
    case setPasscode = 1
    case department = 2
    case item = 3
    
    var viewTitle: String {
        return switch self {
        case .start:        "Welcome to InveX!"
        case .setPasscode:  "Set a passcode"
        case .department:   "Add a department"
        case .item:         "Add an item"
        }
    }
    
}
