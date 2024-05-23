//
//  GlobalEnums.swift
//  InventoryX
//
//  Created by Smetana, Ryan on 4/27/23.
//

import SwiftUI

enum DisplayState: CaseIterable, Hashable {
    case makeASale
    case inventoryList
    case settings
    
    // Specify which views should be layed out differently than main views.
    var prefCol: LazySplitViewColumn {
        return switch self {
        case .settings: .left
        default:        .center
        }
    }
    
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
