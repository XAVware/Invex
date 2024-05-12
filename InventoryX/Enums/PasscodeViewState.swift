//
//  PasscodeViewState.swift
//  InventoryX
//
//  Created by Ryan Smetana on 5/11/24.
//

import Foundation

enum PasscodeViewState {
    case set
    case confirm
    
    var padTitle: String {
        return switch self {
        case .set:      "Enter a passcode"
        case .confirm:  "Enter current passcode"
        }
    }
    
}
