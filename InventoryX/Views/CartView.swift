//
//  CartView.swift
//  InventoryX
//
//  Created by Ryan Smetana on 4/9/24.
//

import SwiftUI


enum CartState {
    case hidden
    case sidebar
    case confirming
}

struct CartView: View {
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
    
    var columns: [GridItem] {
        var colCount = 1
        if uiProperties.width > 600 {
            colCount = 2
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
                                        
                                        Text(item.retailPrice.formatAsCurrencyString())
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
                            SaleItemRowView(item: item, viewType: .cart)
                            Divider().opacity(0.6).padding()
                        } //: ForEach
                        Spacer()
                    } //: Scroll
                    .frame(maxWidth: uiProperties.width, idealHeight: uiProperties.height * 0.7, maxHeight: 800)
                    .environmentObject(vm)
                }
                
                VStack(alignment: cartState == .confirming ? .center : .leading, spacing: 16) {
                    VStack(spacing: uiProperties.width * 0.015) {
                        
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
//                    .frame(maxWidth: cartState == .confirming ? 420 : uiProperties.width)
                    .background(Color("Purple050").opacity(cartState == .confirming ? 0.8 : 0.0))
                    .clipShape(RoundedRectangle(cornerRadius: cartState == .confirming ? 8 : 0))
                    
                    Button {
                        continueTapped()
                    } label: {
                        Spacer()
                        Text("Checkout")
                        Spacer()
                    }
                    .modifier(PrimaryButtonMod())
                    .frame(maxWidth: uiProperties.width)
                } //: VStack
//                .frame(height: uiProperties.height * 0.25)
            } //: Lazy V Grid
            .frame(width: uiProperties.width, height: uiProperties.height)
            .opacity(uiProperties.width < 240 ? 0 : 1)
        } //: VStack
        
    } //: Body
    
    
}

//#Preview {
//    ResponsiveView { props in
//        CartView(cartState: .constant(.sidebar), menuState: .constant(.compact), uiProperties: props)
//            .environmentObject(PointOfSaleViewModel())
//    }
//}

#Preview {
    ResponsiveView { props in
        RootView(uiProperties: props)
            .environment(\.realm, DepartmentEntity.previewRealm)
    }
}



struct SaleItemRowView: View {
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
