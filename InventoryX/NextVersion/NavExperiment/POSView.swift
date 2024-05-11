//
//  PointOfSaleView.swift
//  InventoryX
//
//  Created by Ryan Smetana on 3/26/24.
//

import SwiftUI
import RealmSwift
import Algorithms


struct POSView: View {
    @EnvironmentObject var vm: PointOfSaleViewModel
    @ObservedResults(ItemEntity.self) var items
    @Binding var cartState: CartState
    let uiWidth: CGFloat
    @State var selectedDept: DepartmentEntity?
    
    func toggleCart() {
        var newState: CartState = .closed
        
        /// The cart is allowed to show as a sidebar when the width of the screen is
        /// greater than 680 (a little less than an iPad in portrait mode. If the cart
        /// is being displayed on a smaller screen it should only toggle between taking
        /// up the full width of the screen and being hidden entirely.
        if uiWidth < 680 {
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
            return Array(items)
        }
    }
    
    var body: some View {
        VStack(spacing: 24) {
            DepartmentPicker(selectedDepartment: $selectedDept, style: .scrolling)
            
            /// If 'All' is selected, all items will be returned. Otherwise it will initialize an empty array and populate
            /// it with the items in the selected department, if any.
            ItemGridView(items: selectedDept != nil ? Array(selectedDept?.items ?? .init()) : Array(items)) { item in
                vm.addItemToCart(item)
            }
            .padding(2)
        } //: VStack
        .padding(.horizontal)
    } //: Body
}

#Preview {
    ResponsiveView { props in
        NavView(display: .constant(.pointOfSale)) {
            POSView(cartState: .constant(.sidebar), uiWidth: props.width)
                .environment(\.realm, DepartmentEntity.previewRealm)
                .environmentObject(PointOfSaleViewModel())
//                .toolbar(removing: .sidebarToggle)
//                .navigationBarBackButtonHidden()
        }
        
    }
}


