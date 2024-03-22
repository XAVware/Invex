//
//  RootView.swift
//  InventoryX
//
//  Created by Ryan Smetana on 3/19/24.
//

import SwiftUI
import RealmSwift

struct RootView: View {
    let uiProperties: LayoutProperties
    
    @StateObject var posVM = MakeASaleViewModel()
    
    @State var currentDisplay: DisplayStates = .makeASale
    @State var menuState: MenuState = .compact
    @State var cartState: CartState = .sidebar
    
    @State var selectedDepartment: DepartmentEntity?
    @State var itemTableStyle: TableViewStyle = .grid
    
    
    // Detail view width
    var detailWidth: CGFloat {
        return switch currentDisplay {
        case .makeASale:
            cartState == .sidebar ? (menuState == .open ? uiProperties.width * 0.20 : uiProperties.width * 0.25) : 0
        case .inventoryList:
            0
        case .salesHistory:
            0
        case .settings:
            0
        }
    }
    
    var body: some View {
        HStack {
            if uiProperties.horizontalSizeClass == .regular {
                Menu(display: $currentDisplay, menuState: $menuState)
                    .frame(maxWidth: menuState == .open ? uiProperties.width * 0.2 : nil)
            }
            
            HStack {
                // MARK: - CONTENT
                VStack(spacing: 6) {
                    ToolbarView(menuState: $menuState, cartState: $cartState, itemTableStyle: $itemTableStyle)
                        .padding()
                    
                    switch currentDisplay {
                    case .makeASale:
                        VStack(spacing: 24) {
                            DepartmentPicker(selectedDepartment: $selectedDepartment, style: .scrolling)
                            
                            ItemTableView(department: $selectedDepartment, style: .grid) { item in
                                // If making a sale, add the item to cart. Otherwise select the item so it can be displayed in a add/modify item view.
                                // Handle through protocol
                                posVM.itemTapped(item: item)
                            }
                            
                        } //: VStack
                        .padding(.horizontal)
                        
                    case .inventoryList:
                            
                            ItemTableView(department: $selectedDepartment, style: .list) { item in
                                // If making a sale, add the item to cart. Otherwise select the item so it can be displayed in a add/modify item view.
                                // Handle through protocol
                                posVM.itemTapped(item: item)
                            }
                            
                        
                    case .salesHistory:
                        Text("Sales")
                        
                    case .settings:
                        DepartmentsView()
                    }
                    
                    
                } //: VStack
                
                // MARK: - DETAIL
                if detailWidth > 0 {
                    switch currentDisplay {
                    case .makeASale:
                        CartViewNew(cartState: $cartState, menuState: $menuState)
                            .environmentObject(posVM)
                            .padding()
                            .frame(width: detailWidth)
                            .background(Color("Purple050").opacity(0.5))
                        
                    case .inventoryList:
                        
                            Text("Inventory")
                        
                        
                    case .salesHistory:
                        Text("Sales")
                        
                    case .settings:
                        DepartmentsView()
                    }
                } else {
                    Divider()
                }
            } //: HStack

        } //: HStack
        
    } //: Body
    
}

#Preview {
    ResponsiveView { props in
        RootView(uiProperties: props)
            .environment(\.realm, DepartmentEntity.previewRealm)
    }
}
