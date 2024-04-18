//
//  PointOfSaleView.swift
//  InventoryX
//
//  Created by Ryan Smetana on 3/26/24.
//

import SwiftUI
import RealmSwift
import Algorithms

@MainActor class PointOfSaleViewModel: ObservableObject {
    @Published var cartItems: Array<ItemEntity> = .init()
    @Published var companyName: String = ""
    @Published var taxRate: Double = 0.0
    
    /// Computed array of unique items in the cart. `CartView` uses this to display a section for each item, without re-ordering them. The array of `@Published cartItems` in `PointOfSaleViewModel` can then be queried by the view to find data on each unique item such as the quantity in cart and its subtotal. This allows for re-use of `ItemEntity`. `.uniqued()` requires `Swift Algorithms.`
    var uniqueItems: [ItemEntity] { Array(cartItems.uniqued()) }
    
    var cartSubtotal: Double { cartItems.reduce(0) { $0 + $1.retailPrice } }
    var taxAmount: Double { cartSubtotal * taxRate / 100 }
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
    
    func fetchCompany() {
        do {
            let realm = try Realm()
            if let result = realm.objects(CompanyEntity.self).first {
                self.companyName = result.name
                self.taxRate = result.taxRate
            }
            
            //            tempName = result?.name ?? "Err"
            //            return result?.name ?? "Err"
            
            //            if let result = realm.objects(CompanyEntity.self).first {
            //                self.companyName = result.name
            //                self.taxRateStr = String(format: "%.2f%", Double(result.taxRate))
            //            } else {
            //
            //            }
            //            self.company = realm.objects(CompanyEntity.self).first
        } catch {
            LogService(String(describing: self)).error("Settings VM err")
        }
        
    }
    
    // TODO: Maybe, Only call this when initialized. Then increment stored property.
    func calcNextSaleNumber() -> Int {
        var count: Int = 0
        do {
            let realm = try Realm()
            let salesCount = realm.objects(SaleEntity.self).count
            count = salesCount + 1
        } catch {
            LogService(String(describing: self)).error("Error fetching sales")
        }
        return count
    }
    
    func finalizeSale(completion: @escaping (() -> Void)) async {
        // TODO: 1 & 2 might be able to run at the same time.
        // 1. Update the on-hand quantity for each unique item in the cart
        for index in 0...uniqueItems.count - 1 {
            let tempItem = uniqueItems[index]
            let cartQty = cartItems.filter { $0._id == tempItem._id }.count
            do {
                try await RealmActor().adjustStock(for: tempItem, by: cartQty)
                
            } catch {
                debugPrint("Error saving item in sale: \(tempItem)")
            }
        }
        
//        await uniqueItems.forEach { item in
//            let cartQty = cartItems.filter { $0._id == item._id }.count
//            do {
//                try await RealmActor().adjustStock(for: item, by: cartQty)
//            } catch {
//
//            }
//            if let invItem = item.thaw() {
//                let newOnHandQty = invItem.onHandQty - cartQty
//                do {
//                    let realm = try Realm()
//                    try realm.write {
//                        invItem.onHandQty = newOnHandQty
//                    }
//                } catch {
//                    LogService(String(describing: self)).error("Error adjusting inventory quantities: \(error.localizedDescription)")
//                }
//            } else {
//                LogService(String(describing: self)).error("Unable to thaw item: \(item)")
//            }
//        }

        // 2. Save the sale
        
        // Convert ItemEntities to SaleItemEntities so they can be used in the sale.
        let saleItems = cartItems.map( { SaleItemEntity(item: $0) } )
        
        do {
            try await RealmActor().saveSale(items: saleItems, total: self.total)
            cartItems.removeAll()
            completion()
        } catch {
            
        }
        
//        let newSale = SaleEntity(timestamp: Date(), total: self.total)
//        
//        do {
//            let realm = try Realm()
//            try realm.write {
//                realm.add(newSale)
//                newSale.items.append(objectsIn: saleItems)
//            }
//            
//            cartItems.removeAll()
//            completion()
//        } catch {
//            LogService(String(describing: self)).error("Error saving sale: \(error.localizedDescription)")
//        }
        
    }
}



struct PointOfSaleView: View {
    @EnvironmentObject var vm: PointOfSaleViewModel
    
    @Binding var menuState: MenuState
    @Binding var cartState: CartState
    let uiProperties: LayoutProperties
    @State var selectedDept: DepartmentEntity?
    
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
            if menuState == .open && cartState == .sidebar {
                menuState = .closed
            }
        }
    }
    
    
    var body: some View {
        HStack {
            if cartState != .confirming {
                VStack(spacing: 6) {
                    // MARK: - TOOLBAR
                    HStack {
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
                        
                        if let dept = selectedDept {
                            ItemGridView(items: dept.items) { item in
                                vm.addItemToCart(item)
                            }
                            .padding(2)
                            
                        } else {
                            Spacer()
                        }
                        
//                        ItemGridView(department: $selectedDept) { item in
//                            vm.addItemToCart(item)
//                        }
//                        .padding(2)
                        
                    } //: VStack
                    .padding(.horizontal)
                } //: VStack
            } else {
                
                // MARK: - CART CONFIRMATION VIEW
                /// Make the view disappear entirely when width is 0, otherwise it shows slightly from content.
                /// If the cart is confirmation, it should take up the entire screen width and the menu should be hidden
                CartView(cartState: $cartState, menuState: $menuState, uiProperties: uiProperties)
                    .frame(maxWidth: cartState.idealWidth)
                    .padding()
                    .background(Color("Purple050").opacity(0.25))
                    .environmentObject(vm)
            }
            
            // Sidebar for larger screens
            if uiProperties.width > 680 && cartState == .sidebar {
                ResponsiveView { properties in
                    CartView(cartState: $cartState, menuState: $menuState, uiProperties: properties)
                        .environmentObject(vm)
                }
                .frame(maxWidth: cartState.idealWidth)
                .padding()
                .background(Color("Purple050").opacity(0.5))
            }
        } //: HStack
    } //: Body
}

#Preview {
    ResponsiveView { props in
        PointOfSaleView(menuState: .constant(.open), cartState: .constant(.sidebar), uiProperties: props)
            .environment(\.realm, DepartmentEntity.previewRealm)
            .environmentObject(PointOfSaleViewModel())
    }
}


