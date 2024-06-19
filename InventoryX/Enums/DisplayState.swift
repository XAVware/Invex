
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
//    @ToolbarContentBuilder var toolbar: some ToolbarContent {
//        switch self {
//        case .makeASale:
//            ToolbarItem(placement: .topBarTrailing) {
//                Button("Right Sidebar", systemImage: "cart") {
////                    Task {
////                        await LazySplitService.shared.pushPrimary(.confirmSale, isDetail: false)
////                    }
//                    LazySplitService.shared.pushPrimary(.confirmSale, isDetail: false)
//                }
//            }
//
//        case .inventoryList:
//            ToolbarItem(placement: .topBarTrailing) {
//                Button("Add Item", systemImage: "plus") {
////                    Task {
////                        await LazySplitService.shared.pushPrimary(.item(nil, .create), isDetail: true)
////                    }
//                    LazySplitService.shared.pushPrimary(.item(nil, .create), isDetail: true)
//                }
//            }
//
////            ToolbarItem(placement: .topBarTrailing) {
////                Button("Add \(selectedTableType == .items ? "Item" : "Department")", systemImage: "plus") {
////                    if selectedTableType == .items {
////                        LazySplitService.shared.pushPrimary(.item(nil, .create), isDetail: true)
////    //                    navVM.pushView(.item(nil, .create))
////                    } else {
////                        LazySplitService.shared.pushPrimary(.department(nil, .create), isDetail: true)
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
