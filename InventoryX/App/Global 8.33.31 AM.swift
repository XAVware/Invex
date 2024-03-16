//
//  GlobalEnums.swift
//  InventoryX
//
//  Created by Smetana, Ryan on 4/27/23.
//

import SwiftUI

enum DisplayStates: CaseIterable {
    case dashboard, makeASale, inventoryList, salesHistory, inventoryStatus, settings
    
    var menuButtonText: String {
        switch self {
        case .dashboard: return "Dashboard"
        case .makeASale: return "Sale"
        case .inventoryList: return "Inventory"
        case .salesHistory: return "Sales"
        case .inventoryStatus: return "Status"
        case .settings: return "Settings"
        }
    }
    
    var menuIconName: String {
        switch self {
        case .dashboard: return "square.grid.2x2.fill"
        case .makeASale: return "dollarsign.circle.fill"
        case .inventoryList: return "list.bullet.clipboard.fill"
        case .salesHistory: return "chart.xyaxis.line"
        case .inventoryStatus: return "text.badge.checkmark"
        case .settings: return "gearshape"
        }
    }
    
    var contentWidthMultiplier: CGFloat {
        switch self {
        case .dashboard: return 1.0
        case .makeASale: return 0.66
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
    case hidden, bar, quarter, third, half, full
    
    var percentVal: CGFloat {
        switch self {
        case .hidden:   return 1.0
        case .bar:      return 0.95
        case .quarter:  return 0.75
        case .third:    return 0.66
        case .half:     return 0.5
        case .full:     return 0.0
        }
    }
}

let dayTimeInterval: Double = 86400

let toolbarHeight: CGFloat = 24
