//
//  PointOfSaleView.swift
//  InventoryX
//
//  Created by Ryan Smetana on 3/26/24.
//

import SwiftUI
import RealmSwift
import Algorithms

/// Cart States
/// While the cart is editable and displayed as a sidebar, the ReceiptTotals sections reserves 25% of the view's height, the title reserves x%, and the scrollview containing the items reserves the remaining x%
///
/// Sidebar should only display when the view's width is over 900 pixels. This would allow iPads and larger iPhones to display it while in landscape mode, but hide it while in portrait.

@MainActor class PointOfSaleViewModel: ObservableObject {
    @Published var cartItems: Array<ItemEntity> = .init()
    
    /// Computed array of unique items in the cart. `CartView` uses this to display a section for each item, without re-ordering them. The array of `@Published cartItems` in `PointOfSaleViewModel` can then be queried by the view to find data on each unique item such as the quantity in cart and its subtotal. This allows for re-use of `ItemEntity`. `.uniqued()` requires `Swift Algorithms.`
    var uniqueItems: [ItemEntity] { Array(cartItems.uniqued()) }
    
    var cartSubtotal: Double { cartItems.reduce(0) { $0 + $1.retailPrice } }
    var taxAmount: Double { cartSubtotal * 0.07 }
    var total: Double { cartSubtotal + taxAmount }
    
    var cartItemCount: Int { cartItems.count }
    
    func addItemToCart(_ item: ItemEntity) {
        cartItems.append(item)
    }
    
    func removeItemFromCart(_ item: ItemEntity) {
        if let itemIndex = cartItems.firstIndex(of: item) {
            cartItems.remove(at: itemIndex)
        }
    }
    
    func finalizeSale(completion: @escaping (() -> Void)) {
        // TODO: 1 & 2 might be able to run at the same time.
        // 1. Update the on-hand quantity for each unique item in the cart
        uniqueItems.forEach { item in
            let cartQty = cartItems.filter { $0._id == item._id }.count
            if let invItem = item.thaw() {
                let newOnHandQty = invItem.onHandQty - cartQty
                do {
                    let realm = try Realm()
                    try realm.write {
                        invItem.onHandQty = newOnHandQty
                    }
                } catch {
                    LogService(String(describing: self)).error("Error adjusting inventory quantities: \(error.localizedDescription)")
                }
            } else {
                LogService(String(describing: self)).error("Unable to thaw item: \(item)")
            }
        }
        
        // 2. Save the sale
        let newSale = SaleEntity(timestamp: Date(), total: self.total)
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(newSale)
            }
            
            cartItems.removeAll()
            completion()
        } catch {
            LogService(String(describing: self)).error("Error saving sale: \(error.localizedDescription)")
        }
    }
}

struct PointOfSaleView: View {
    @EnvironmentObject var vm: PointOfSaleViewModel
    
    @Binding var menuState: MenuState
    @Binding var cartState: CartState
    let uiProperties: LayoutProperties
    @State var selectedDept: DepartmentEntity?
    
    
//    @State var cartWidth: CGFloat = 280
    
    func toggleCart() {
        
        withAnimation(.smooth) {
            if uiProperties.width < 680 {
                print("Small Screen")
                cartState = .confirming
            } else {
                
                switch cartState {
                case .hidden:
                    cartState = .sidebar
                case .sidebar:
                    cartState = .hidden
                case .confirming:
                    cartState = .confirming
                }
            }
        }
    }
    
    
    var body: some View {
        HStack {
            if cartState != .confirming {
                VStack(spacing: 6) {
                    // MARK: - TOOLBAR
                    HStack(spacing: 32) {
                        Spacer()
                        Button {
                            toggleCart()
                        } label: {
                            Image(systemName: "cart")
                        }
                    } //: HStack
                    .font(.title)
                    .padding()
                    .fontDesign(.rounded)
                    
                    
                    // MARK: - ITEM PANE
                    VStack(spacing: 24) {
                        DepartmentPicker(selectedDepartment: $selectedDept, style: .scrolling)
                        
                        ItemTableView(department: $selectedDept, style: .grid) { item in
                            vm.addItemToCart(item)
                        }
                        .padding(2)
                        
                    } //: VStack
                    .padding(.horizontal)
                } //: VStack
            } else {
    
                // MARK: - CART CONFIRMATION VIEW
                CartView(cartState: $cartState, menuState: $menuState, uiProperties: uiProperties)
                    .frame(maxWidth: cartState.idealWidth)
                    .padding()
                    .background(Color("Purple050").opacity(0.5))
                    .environmentObject(vm)
            }
            
            // Sidebar for larger screens
            if uiProperties.width > 680 && cartState != .confirming {
                ResponsiveView { properties in
                    CartView(cartState: $cartState, menuState: $menuState, uiProperties: properties)
                        .environmentObject(vm)
                }
                .frame(maxWidth: cartState.idealWidth)
                .padding()
                .background(Color("Purple050").opacity(0.5))
            }
            
            /// Make the view disappear entirely when width is 0, otherwise it shows slightly from content.
            /// If the cart is confirmation, it should take up the entire screen width.
//            if cartState == .confirming {
//                ResponsiveView { properties in
//                    CartView(cartState: $cartState, menuState: $menuState, uiProperties: properties)
//                        .environmentObject(vm)
//                }
//                .frame(maxWidth: cartState.idealWidth)
//                .padding()
//                .background(Color("Purple050").opacity(0.5))
//            } else if cartState != .hidden {
//                
//            }
            
            
            
//            if cartState != .hidden {
//                // Cart does not show when view width is less than ~width of vertical iPhone 15
//                if uiProperties.width < 680 {
////                    if cartState != .hidden {
//                        ResponsiveView { properties in
//                            CartView(cartState: $cartState, menuState: $menuState, uiProperties: properties)
//                                .environmentObject(vm)
//                        }
//                        .frame(maxWidth: cartState.idealWidth)
//                        .padding()
//                        .background(Color("Purple050").opacity(0.5))
////                    }
//                } else {
//                    if cartState != .confirming {
//                        ResponsiveView { properties in
//                            CartView(cartState: $cartState, menuState: $menuState, uiProperties: properties)
//                                .environmentObject(vm)
//                        }
//                        .frame(maxWidth: cartState.idealWidth)
//                        .padding()
//                        .background(Color("Purple050").opacity(0.5))
//                    }
//                    
//                }
//                
//            }
//            if uiProperties.width < 680 {
//                if cartState != .hidden {
//                    ResponsiveView { properties in
//                        CartView(cartState: $cartState, menuState: $menuState, uiProperties: properties)
//                            .environmentObject(vm)
//                    }
//                    .frame(maxWidth: cartState.idealWidth)
//                    .padding()
//                    .background(Color("Purple050").opacity(0.5))
//                }
//            } else {
//                if cartState != .hidden && cartState != .confirming {
//                    ResponsiveView { properties in
//                        CartView(cartState: $cartState, menuState: $menuState, uiProperties: properties)
//                            .environmentObject(vm)
//                    }
//                    .frame(maxWidth: cartState.idealWidth)
//                    .padding()
//                    .background(Color("Purple050").opacity(0.5))
//                }
//                
//            }
            
            
        } //: HStack
    }
}

#Preview {
    ResponsiveView { props in
        PointOfSaleView(menuState: .constant(.compact), cartState: .constant(.sidebar), uiProperties: props)
            .environment(\.realm, DepartmentEntity.previewRealm)
            .environmentObject(PointOfSaleViewModel())
    }
}


