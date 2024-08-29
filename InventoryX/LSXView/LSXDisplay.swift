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
    
    case company(CompanyEntity, DetailType)
    case passcodePad([PasscodeViewState])
    case department(DepartmentEntity?, DetailType)
    case item(ItemEntity?, DetailType)
    case confirmSale

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
}
