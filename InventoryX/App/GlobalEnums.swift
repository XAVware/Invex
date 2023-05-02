//
//  GlobalEnums.swift
//  InventoryX
//
//  Created by Smetana, Ryan on 4/27/23.
//

import SwiftUI

enum DisplayStates: CaseIterable {
    case makeASale, addInventory, inventoryList, salesHistory, inventoryStatus
    
    var menuButtonText: String {
        switch self {
        case .makeASale: return "Sale"
        case .addInventory: return "Restock"
        case .inventoryList: return "Inventory"
        case .salesHistory: return "Sales"
        case .inventoryStatus: return "Reorder"
        }
    }
    
    var iconName: String {
        switch self {
        case .makeASale: return "dollarsign.circle.fill"
        case .addInventory: return "cart.fill.badge.plus"
        case .inventoryList: return "list.bullet.clipboard.fill"
        case .salesHistory: return "chart.xyaxis.line"
        case .inventoryStatus: return "text.badge.checkmark"
        }
    }
}


enum SaveResult {
    case success, failure
}
