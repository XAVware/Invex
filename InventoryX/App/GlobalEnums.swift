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
        case .makeASale:
            return "Make A Sale"
        case .addInventory:
            return "Add Inventory"
        case .inventoryList:
            return "Inventory List"
        case .salesHistory:
            return "Sales History"
        case .inventoryStatus:
            return "Inventory Status"
        }
    }
}
