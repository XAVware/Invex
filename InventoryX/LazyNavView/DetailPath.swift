//
//  DetailPath.swift
//  CustomSplitView
//
//  Created by Ryan Smetana on 5/19/24.
//

import SwiftUI

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
    case confirmSale(Array<ItemEntity>)
//    case confirmSale(StateObject<PointOfSaleViewModel>)
//    case confirmSale(PointOfSaleViewModel)
    
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
//    @ToolbarContentBuilder var toolbar: some ToolbarContent {
//        switch self {
//        case .makeASale:
//            ToolbarItem(placement: .topBarTrailing) {
//                Button("Right Sidebar", systemImage: "cart") {
////                    Task {
////                        await LazySplitService.shared.pushPrimary(.confirmSale)
////                    }
//                    LazySplitService.shared.pushPrimary(.confirmSale)
//                }
//            }
//            
//        case .inventoryList:
//            ToolbarItem(placement: .topBarTrailing) {
//                Button("Add Item", systemImage: "plus") {
////                    Task {
////                        await LazySplitService.shared.pushPrimary(.item(nil, .create))
////                    }
//                    LazySplitService.shared.pushPrimary(.item(nil, .create))
//                }
//            }
//            
////            ToolbarItem(placement: .topBarTrailing) {
////                Button("Add \(selectedTableType == .items ? "Item" : "Department")", systemImage: "plus") {
////                    if selectedTableType == .items {
////                        LazySplitService.shared.pushPrimary(.item(nil, .create))
////    //                    navVM.pushView(.item(nil, .create))
////                    } else {
////                        LazySplitService.shared.pushPrimary(.department(nil, .create))
////    //                    navVM.pushView(.department(nil, .create))
////                    }
////                }
////                .buttonStyle(BorderedButtonStyle())
////                
////            }
//        default:
//            ToolbarItem(placement: .topBarTrailing) {
//                EmptyView()
//            }
//            
//        }
        
        
//    }

}
