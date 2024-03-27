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
                    LogService(self).error("Error adjusting inventory quantities: \(error.localizedDescription)")
                }
            } else {
                LogService(self).error("Unable to thaw item: \(item)")
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
            LogService(self).error("Error saving sale: \(error.localizedDescription)")
        }
    }
}

struct PointOfSaleView: View {
    @EnvironmentObject var vm: PointOfSaleViewModel
    
    @Binding var menuState: MenuState
    @Binding var cartState: CartState
    @Binding var display: DisplayState
    
    @State var selectedDept: DepartmentEntity?
    
    var body: some View {
        HStack {
            if cartState != .confirming {
                VStack(spacing: 6) {
                    ToolbarView(menuState: $menuState, cartState: $cartState, display: $display)
                        .padding()
                
                
                    VStack(spacing: 24) {
                        DepartmentPicker(selectedDepartment: $selectedDept, style: .scrolling)
                        
                        ItemTableView(department: $selectedDept, style: .grid) { item in
                            vm.addItemToCart(item)
                        }
                        .padding(2)
                        
                    } //: VStack
                    .padding(.horizontal)
                } //: VStack
            }
            

            ResponsiveView { properties in
                CartViewNew(cartState: $cartState, menuState: $menuState, uiProperties: properties)
                    .environmentObject(vm)
                
            }
            .padding()
            .frame(maxWidth: cartState == .confirming ? .infinity : 300)
            .background(Color("Purple050").opacity(0.5))
                
        } //: HStack
    }
}

#Preview {
    PointOfSaleView(menuState: .constant(.compact), cartState: .constant(.sidebar), display: .constant(.makeASale))
        .environment(\.realm, DepartmentEntity.previewRealm)
        .environmentObject(PointOfSaleViewModel())
}

enum CartState {
    case hidden
    case sidebar
    case confirming
}

struct CartViewNew: View {
    @EnvironmentObject var vm: PointOfSaleViewModel
    
    @Binding var cartState: CartState
    @Binding var menuState: MenuState
    
    @State var origWidth: CGFloat = 0
    
    let uiProperties: LayoutProperties
    
    func continueTapped() {
        switch cartState {
        case .hidden:   return
        case .sidebar:  cartState = .confirming
        case .confirming:
            vm.finalizeSale {
                /// Once the sale saves successfully, return the cart to its original state.
                cartState = .sidebar
            }
        }
    }
    
    var paddingVal: CGFloat {
        return cartState == .confirming ? 16 : 8
    }
    
    var columns: [GridItem] {
        var colCount = 1
        if uiProperties.width > 600 {
            colCount += 1
        }
        return Array(repeating: GridItem(.flexible(minimum: 300, maximum: .infinity), spacing: 16), count: colCount)
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Text(cartState == .confirming ? "Order Summary" : "Cart")
                .font(cartState == .confirming ? .largeTitle : .title2)
                .fontWeight(cartState == .confirming ? .bold : .regular)
                .fontDesign(cartState == .confirming ? .rounded : .default)
                .frame(maxWidth: .infinity)
                .frame(height: uiProperties.height * 0.05)
            
            LazyVGrid(columns: columns) {
                if cartState == .confirming {
                    // MARK: - CONFIRMATION VIEW
                    VStack(spacing: 16) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Sale #123456")
                                    .font(.headline)
                                Text("Company Name")
                                    .font(.subheadline)
                            } //: VStack
                            
                            Spacer()
                            
                            VStack(alignment: .trailing) {
                                Text(Date().formatted(date: .long, time: .omitted))
                                Text(Date().formatted(date: .omitted, time: .shortened))
                            } //: VStack
                        } //: HStack
                        
                        HStack {
                            Text("Item")
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Text("Price")
                                .frame(maxWidth: .infinity)
                            
                            Text("Subtotal")
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        } //: HStack
                        .font(.callout)
                        .foregroundStyle(.black)
                        
                        Divider().opacity(0.4)
                        
                        ScrollView(.vertical, showsIndicators: false) {
                            VStack {
                                ForEach(vm.uniqueItems) { item in
                                    HStack {
                                        VStack(alignment: .leading) {
                                            Text(item.name)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                            Text("Qty: \(vm.cartItems.filter { $0._id == item._id }.count)")
                                        } //: VStack
                                        
                                        Text(item.retailPrice?.formatAsCurrencyString() ?? "Error")
                                            .frame(maxWidth: .infinity)
                                        
//                                        Text(item.cartItemSubtotal.formatAsCurrencyString())
//                                            .frame(maxWidth: .infinity, alignment: .trailing)
                                        
                                    } //: HStack
                                    .font(.callout)
                                    .foregroundStyle(.black)
                                    .frame(height: 30)
                                    .padding(.vertical, 12)

                                    Divider().opacity(0.4)
                                } //: ForEach
                            } //: VStack
                            Spacer()
                        } //: ScrollView
                        .frame(minHeight: 400, idealHeight: uiProperties.height * 0.65, maxHeight: 800)
                        Spacer()
                    } //: VStack
                    .padding()
                    .modifier(GlowingOutlineMod())
                } else {
                    // MARK: - CART VIEW
                    ScrollView {
                        ForEach(vm.uniqueItems) { item in
                            SaleItemView(item: item, viewType: .cart)
                            Divider().opacity(0.6).padding()
                        } //: ForEach
                        Spacer()
                    } //: Scroll
                    .frame(maxWidth: uiProperties.width, idealHeight: uiProperties.height * 0.7, maxHeight: 800)
                    .environmentObject(vm)
                }
            
                VStack(alignment: cartState == .confirming ? .center : .leading, spacing: 16) {
                    VStack(spacing: uiProperties.height * 0.006) {
                        
                        HStack {
                            Text("Subtotal:")
                            Spacer()
                            Text("\(vm.cartSubtotal.formatAsCurrencyString())")
                        } //: HStack
                        .font(cartState == .confirming ? .title3 : .subheadline)
                        .fontWeight(.regular)
                        
                        HStack {
                            Text("Tax:")
                            Spacer()
                            Text("\(vm.taxAmount.formatAsCurrencyString())")
                        } //: HStack
                        .font(cartState == .confirming ? .title3 : .subheadline)
                        .fontWeight(.regular)
                        
                        if cartState == .confirming {
                            Divider()
                        }
                        
                        HStack {
                            Text("Total:")
                            Spacer()
                            Text(vm.total.formatAsCurrencyString())
                        } //: HStack
                        .font(cartState == .confirming ? .title2 : .subheadline)
                        .fontWeight(.semibold)
                        
                    } //: VStack
                    .padding(cartState == .confirming ? 16 : 0)
                    .frame(maxWidth: cartState == .confirming ? 420 : uiProperties.width)
                    .background(Color("Purple050").opacity(cartState == .confirming ? 0.8 : 0.0))
                    .clipShape(RoundedRectangle(cornerRadius: cartState == .confirming ? 8 : 0))
                    
                    Button {
                        continueTapped()
                    } label: {
                        Text("Checkout")
                    }
                    .modifier(PrimaryButtonMod())
                    .frame(maxWidth: uiProperties.width)
                } //: VStack
                .frame(height: uiProperties.height * 0.25)
            } //: Lazy V Grid
            .frame(width: uiProperties.width, height: uiProperties.height)
        } //: VStack
        
    } //: Body
    
    
}


struct SaleItemView: View {
    enum ViewType { case cart, receipt }
    @EnvironmentObject var vm: PointOfSaleViewModel
    
    @State var item: ItemEntity
    @State var viewType: ViewType
    
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            HStack {
                Text(item.name)
                    .font(.subheadline)
                Spacer()

                Text(item.retailPrice.formatAsCurrencyString())
                    .font(.subheadline)
            } //: HStack
            
            Stepper("x \(vm.cartItems.filter { $0._id == item._id }.count)") {
                vm.addItemToCart(item)
            } onDecrement: {
                vm.removeItemFromCart(item)
            }
//            .frame(maxWidth: uiProperties.width)
        } //: VStack
    }
}
