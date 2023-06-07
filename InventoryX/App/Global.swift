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
    
    var detailWidthPercentage: CGFloat {
        switch self {
        case .dashboard: return 1.0
        case .makeASale: return 0.66
        case .addInventory: return 1.0
        case .inventoryList: return 1.0
        case .salesHistory: return 1.0
        case .inventoryStatus: return 1.0
        case .settings: return 1.0
        }
    }
}

enum RealmResult {
    case success, error
}

enum DetailSize {
    case quarter, third, half, full
    
    var percentVal: CGFloat {
        switch self {
        case .quarter:
            return 0.75
        case .third:
            return 0.66
        case .half:
            return 0.5
        case .full:
            return 0.0
        }
    }
}

let dayTimeInterval: Double = 86400
