//
//  PointOfSaleView.swift
//  InventoryX
//
//  Created by Ryan Smetana on 3/26/24.
//

import SwiftUI
import RealmSwift
import Algorithms


struct NewPointOfSaleView: View {
    @EnvironmentObject var vm: PointOfSaleViewModel
    @ObservedResults(ItemEntity.self) var items
//    @Binding var menuState: MenuState
    @Binding var cartState: CartState
    let uiProperties: LayoutProperties
    @State var selectedDept: DepartmentEntity?
//    @Binding var currentDisplay: NewDisplayState
    func toggleCart() {
        var newState: CartState = .closed
        
        /// The cart is allowed to show as a sidebar when the width of the screen is
        /// greater than 680 (a little less than an iPad in portrait mode. If the cart
        /// is being displayed on a smaller screen it should only toggle between taking
        /// up the full width of the screen and being hidden entirely.
        if uiProperties.width < 680 {
            newState = .confirming
        } else {
            switch cartState {
            case .closed:
                newState = .sidebar
            case .sidebar:
                newState = .closed
            case .confirming:
                newState = .confirming
            }
        }
        
        // Make sure cart is not empty before displaying confirmation
        if newState == .confirming {
            guard !vm.cartItems.isEmpty else { return }
        }
        
        withAnimation(.interpolatingSpring) {
            cartState = newState
            // If the new cart state is sidebar, close the menu if its open.
//            if menuState == .open && cartState == .sidebar {
//                menuState = .closed
//            }
        }
    }
    
    func getItems() -> Array<ItemEntity>{
        if let dept = selectedDept {
            return Array(dept.items)
        } else {
            Task {
                do {
                    let items = try RealmActor().fetchAllItems()
                    return Array(items)
                } catch {
                    debugPrint(error.localizedDescription)
                    return Array()
                }
            }
            return Array()
        }
    }
    
    var body: some View {

            // MARK: - ITEM PANE
            VStack(spacing: 24) {
                DepartmentPicker(selectedDepartment: $selectedDept, style: .scrolling)
                
                if let dept = selectedDept {
                    ItemGridView(items: Array(dept.items)) { item in
                        vm.addItemToCart(item)
                    }
                    .padding(2)
                    
                } else {
                    ItemGridView(items: Array(items)) { item in
                        vm.addItemToCart(item)
                    }
                    .padding(2)
                }
                
            } //: VStack
            .padding(.horizontal)
            .navigationBarTitleDisplayMode(.inline)
            .navigationSplitViewStyle(.prominentDetail)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Cart", systemImage: "cart") {
                        
                    }
                }
            }

        
    } //: Body
}

//#Preview {
//    ResponsiveView { props in
//        NewPointOfSaleView(cartState: .constant(.sidebar), uiProperties: props)
//            .environment(\.realm, DepartmentEntity.previewRealm)
//            .environmentObject(PointOfSaleViewModel())
//    }
//}


