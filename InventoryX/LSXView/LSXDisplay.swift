//
//  DisplayState.swift
//  GenericSplitView
//
//  Created by Ryan Smetana on 5/9/24.
//

import SwiftUI

enum LSXDisplayMode { case detailOnly, besideDetail }

enum LSXViewType: Identifiable, Hashable {
    var id: LSXViewType { return self }
    case primary
    case detail
}

enum LSXDisplay: Hashable, CaseIterable {
    // Main displays
    static var allCases: [LSXDisplay] { [.pos, .inventoryList, .settings] }
    
    case pos
    case inventoryList
    case settings
    
    case company
    case passcodePad([PasscodeViewState])
    case department(DepartmentEntity?, DetailType)
    case item(ItemEntity?, DetailType)
    case confirmSale([CartItem])
    
    case lock

    var displayMode: LSXDisplayMode {
        return switch self {
        case .settings:     .besideDetail
        default:            .detailOnly
        }
    }

    var defaultViewType: LSXViewType {
        return switch self {
        case .pos:         .primary
        case .inventoryList: .primary
        case .settings:     .primary
        default:            .detail
        }
    }
    
    var showsTabBarDivider: Bool {
        return switch self {
        case .pos, .settings: true
        default: false
        }
    }
    
    
//    var tabId: Int {
//        return switch self {
//        case .pos: 0
//        case .inventoryList: 1
//        case .settings: 2
//        default: -1
//        }
//    }
}
