//
//  ActiveOrderView.swift
//  InventoryX
//
//  Created by Ryan Smetana on 3/16/24.
//

import SwiftUI
import RealmSwift

enum ViewState: CaseIterable {
    case dashboard, makeASale, inventoryList, salesHistory, settings
    
    var menuButtonText: String {
        return switch self {
        case .dashboard:        "Dashboard"
        case .makeASale:        "Sale"
        case .inventoryList:    "Inventory"
        case .salesHistory:     "Sales"
        case .settings:         "Settings"
        }
    }
    
    var menuIconName: String {
        return switch self {
        case .dashboard:        "square.grid.2x2.fill"
        case .makeASale:        "dollarsign.circle.fill"
        case .inventoryList:    "list.bullet.clipboard.fill"
        case .salesHistory:     "chart.xyaxis.line"
        case .settings:         "gearshape"
        }
    }
}
