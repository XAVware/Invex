//
//  OnboardingState.swift
//  InventoryX
//
//  Created by Ryan Smetana on 5/11/24.
//

import Foundation

enum OnboardingState: Int, Hashable {
    case start = 0
    case company = 1
    case setPasscode = 2
    case department = 3
    case item = 4
    
    var viewTitle: String {
        return switch self {
        case .start:        "Welcome to InveX!"
        case .setPasscode:  "Set a passcode"
        case .department:   "Add a department"
        case .item:         "Add an item"
        case .company:      "Company Name"
        }
    }
    
}
