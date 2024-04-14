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
    case salesHistory
    case departments
    case settings
    
    var menuButtonText: String {
        return switch self {
        case .makeASale:        "Sale"
        case .inventoryList:    "Inventory"
        case .departments:      "Departments"
        case .salesHistory:     "Sales"
        case .settings:         "Settings"
        }
    }
    
    var menuIconName: String {
        return switch self {
        case .makeASale:        "cart.fill"
        case .inventoryList:    "tray.full.fill"
        case .departments:      "building.2.fill"
        case .salesHistory:     "chart.xyaxis.line"
        case .settings:         "gearshape"
        }
    }
}
