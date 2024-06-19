//
//  GlobalEnums.swift
//  InventoryX
//
//  Created by Smetana, Ryan on 4/27/23.
//

import SwiftUI

// When using LazySplitService, the first case will be the default.
// I removed Hashable when importing LazySplit. If errors occur, it may need to be added back.
enum DisplayState: CaseIterable {
    case makeASale
    case inventoryList
    case settings
    
    case onboarding
    
    var viewTitle: String {
        return switch self {
        case .makeASale:        "Make A Sale"
        case .inventoryList:    "Inventory"
        default:                ""
        }
    }
    
    var displayMode: LazySplitDisplayMode {
        return switch self {
        case .settings:     .besideDetail
        default:            .detailOnly
        }
    }
}
