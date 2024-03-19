//
//  GlobalEnums.swift
//  InventoryX
//
//  Created by Smetana, Ryan on 4/27/23.
//

import SwiftUI

enum DisplayStates: CaseIterable {
    case makeASale, inventoryList, salesHistory, settings
    
    var menuButtonText: String {
        return switch self {
        case .makeASale:        "Sale"
        case .inventoryList:    "Inventory"
        case .salesHistory:     "Sales"
        case .settings:         "Settings"
        }
    }
    
    var menuIconName: String {
        return switch self {
        case .makeASale:        "cart.fill"
        case .inventoryList:    "tray.full.fill"
        case .salesHistory:     "chart.xyaxis.line"
        case .settings:         "gearshape"
        }
    }
    
    var contentWidthMultiplier: CGFloat {
        return switch self {
        case .makeASale:        0.66
        case .inventoryList:    1.0
        case .salesHistory:     1.0
        case .settings:         1.0
        }
    }
}

enum RealmResult {
    case success, error
}

enum DetailSize {
    case hidden, bar, quarter, third, half, full
    
    var percentVal: CGFloat {
        return switch self {
        case .hidden:   1.0
        case .bar:      0.95
        case .quarter:  0.75
        case .third:    0.66
        case .half:     0.5
        case .full:     0.0
        }
    }
}

let dayTimeInterval: Double = 86400

let toolbarHeight: CGFloat = 24
