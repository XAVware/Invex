//
//  GlobalEnums.swift
//  InventoryX
//
//  Created by Smetana, Ryan on 4/27/23.
//

import SwiftUI

enum DisplayStates: CaseIterable {
    case dashboard, makeASale, addInventory, inventoryList, salesHistory, inventoryStatus, settings
    
    var menuButtonText: String {
        switch self {
        case .dashboard: return "Dashboard"
        case .makeASale: return "Sale"
        case .addInventory: return "Restock"
        case .inventoryList: return "Inventory"
        case .salesHistory: return "Sales"
        case .inventoryStatus: return "Reorder"
        case .settings: return "Settings"
        }
    }
    
    var iconName: String {
        switch self {
        case .dashboard: return "square.grid.2x2.fill"
        case .makeASale: return "dollarsign.circle.fill"
        case .addInventory: return "cart.fill.badge.plus"
        case .inventoryList: return "list.bullet.clipboard.fill"
        case .salesHistory: return "chart.xyaxis.line"
        case .inventoryStatus: return "text.badge.checkmark"
        case .settings: return "gearshape"
        }
    }
}


enum SaveResult {
    case success, failure
}

let dayTimeInterval: Double = 86400
