//
//  NavExperiment.swift
//  InventoryX
//
//  Created by Ryan Smetana on 4/18/24.
//

/// Navigation Architecture
///
/// Problem: The overall flow of the app is similar to the built in flow of a NavigationSplitView. The menu could be a sidebar but that would require that views like Settings to have a Content view while other screens like PointOfSaleView to have empty Content in the split view. NavigationSplitView doesn't act correct if you attempt to use empty views or dynamically move views from sidebar-content-detail depending on the screen.
///
/// Solution: Use a ZStack to show and hide the menu and a NavigationSplit view that only has a sidebar and detail for the main content of the app.
/// Hide the default sidebar button so I can create a replica and add additional logic. The button needs to check what view is open and either show the menu or show the sidebar depending on what is required.
/// Majority of views will have a column visibility state of detailOnly, while views like settings will use .doubleColumn. In iOS 17 you can use PreferredCompactColumn to default to .detailView for PointOfSaleView, InventoryListView, etc. while using .sidebar for SettingsView.

import SwiftUI
import RealmSwift


enum NewDisplayState: CaseIterable {
    case pointOfSale
    case inventoryList
//    case salesHistory
    case settings
    
    var menuButtonText: String {
        return switch self {
        case .pointOfSale:        "Sale"
        case .inventoryList:    "Inventory"
//        case .salesHistory:     "Sales"
        case .settings:         "Settings"
        }
    }
    
    var menuIconName: String {
        return switch self {
        case .pointOfSale:        "cart.fill"
        case .inventoryList:    "tray.full.fill"
//        case .salesHistory:     "chart.xyaxis.line"
        case .settings:         "gearshape"
        }
    }
    
    var primaryView: NavigationSplitViewVisibility {
            return switch self {
            case .pointOfSale: .detailOnly
            case .inventoryList: .detailOnly
            case .settings: .doubleColumn
            }
        
    }
    
    /// The preferred compact column should always be the same as the `primaryView`
    var prefCompColumn: NavigationSplitViewColumn {
        return primaryView == .detailOnly ? .detail : .content
    }
    
    /// A display state requires a custom menu if the layout has a view it wants to display in the `sidebar` section of the split view. If there is something in the sidebar section, the sidebar can't be used for the menu so a custom menu is required.
//    var requiresCustomMenu: Bool {
//        return switch self {
//        case .pointOfSale:      false
//        case .inventoryList:    false
//        case .settings:         true
//        }
//    }
    
//    var isDetailProminent: Bool {
//        return switch self {
//        case .pointOfSale:      true
//        case .inventoryList:    true
//        case .settings:         false
//        }
//    }

}



struct NewRootView: View {
    
    // ROOT VIEW
    let uiProperties: LayoutProperties
    @StateObject var rootVM = RootViewModel()
    @StateObject var posVM = PointOfSaleViewModel()
    @State var currentDisplay: NewDisplayState = .pointOfSale
    @State var cartState: CartState = .closed
    
    var body: some View {
        ZStack {
                
            NavView(display: $currentDisplay) {
                navSplitViewContent
                    .navigationBarTitleDisplayMode(.inline)
            } detail: {
                NavigationStack {
                    detailView
                }
            }
//            cartLayer
            
        } //: ZStack
        
    } //: Body
    
    /// The content/middle pane of the navigationSplitView should only show on the SettingsView
    @ViewBuilder var navSplitViewContent: some View {
        if currentDisplay == .settings {
            NewSettingsView()
        }
    }
    
    
    @ViewBuilder var detailView: some View { 
        switch currentDisplay {
        case .pointOfSale:
            POSView(cartState: .constant(.sidebar), uiWidth: uiProperties.width)
                .environmentObject(posVM)
                .navigationBarBackButtonHidden(true)
                .navigationBarTitleDisplayMode(.inline)
                .navigationSplitViewStyle(.prominentDetail)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Cart", systemImage: "cart") {
                            
                        }
                    }
                }
            
        case .inventoryList:
            NewInventoryListView()

            
        default: Color.clear
            
        }
    }
    
    @ViewBuilder var cartLayer: some View {
        HStack {
            Spacer()
            NewCartView(cartState: $cartState, uiProperties: uiProperties)
//                .frame(maxWidth: cartState.width)
        }
    }
    
}

#Preview {
    ResponsiveView { props in
        NewRootView(uiProperties: props, cartState: CartState.sidebar)
            .environment(\.realm, DepartmentEntity.previewRealm)
            .environmentObject(PointOfSaleViewModel())
    }
}
