//
//  GlobalEnums.swift
//  InventoryX
//
//  Created by Smetana, Ryan on 4/27/23.
//

import SwiftUI

enum DisplayState: CaseIterable {
    case makeASale
    case inventoryList
    case settings
    
    var menuButtonText: String {
        return switch self {
        case .makeASale:        "Sale"
        case .inventoryList:    "Inventory"
        case .settings:         "Settings"
        }
    }
    
    var menuIconName: String {
        return switch self {
        case .makeASale:        "cart.fill"
        case .inventoryList:    "tray.full.fill"
        case .settings:         "gearshape"
        }
    }
}
