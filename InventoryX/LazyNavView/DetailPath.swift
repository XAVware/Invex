//
//  DetailPath.swift
//  CustomSplitView
//
//  Created by Ryan Smetana on 5/19/24.
//

import Foundation

enum DetailType: Identifiable, Hashable {
    case onboarding
    case create
    case read
    case update
//    , delete
    
    var id: DetailType { return self }
}


// Hashable because 'Instance method 'append' requires that 'DetailPath' conform to 'Hashable'

enum DetailPath: Identifiable, Hashable {
    var id: DetailPath { return self }
    
    case company(CompanyEntity, DetailType)
    case passcodePad([PasscodeViewState])
    case department(DepartmentEntity?, DetailType)
    case item(ItemEntity?, DetailType)
    case confirmSale
    
//    var viewTitle: String {
//        return switch self {
//        case .passcodePad(let s, let t):  "\(s.last == .set ? "Set" : "Re-enter") a passcode"
//        case .department:   "Add a department"
//        case .item:         "Add an item"
//        case .company:      "Company"
//        case .confirmSale:  "Confirm Sale"
//        }
//    }
}



enum LazySplitDisplayMode { case detailOnly, besideDetail }

// When using LazySplitService, the first case will be the default.
// I removed Hashable when importing LazySplit. If errors occur, it may need to be added back.
enum DisplayState: CaseIterable {
    case makeASale
    case inventoryList
    case settings
    
    case onboarding
    
    var viewTitle: String {
        return switch self {
        case .makeASale:        "Home"
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
