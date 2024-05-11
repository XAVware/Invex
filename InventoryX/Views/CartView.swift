//
//  CartView.swift
//  InventoryX
//
//  Created by Ryan Smetana on 4/9/24.
//

import SwiftUI


enum CartState {
    case closed
    case sidebar
    case confirming
    
    var idealWidth: CGFloat {
        switch self {
        case .closed:
            return 0
        case .sidebar:
            return 240
        case .confirming:
            return .infinity
        }
    }
}

/// Changing the opacity based on screenwidth improves the animation when hiding the cart.

struct CartView: View {
    @EnvironmentObject var vm: PointOfSaleViewModel
    
    @Binding var cartState: CartState
    @Binding var menuState: MenuState
        
    let uiProperties: LayoutProperties
    
    func continueTapped() {
        
        switch cartState {
        case .closed:   return
        case .sidebar:  cartState = .confirming
        case .confirming:
            guard !vm.cartItems.isEmpty else { return }
            Task {
                // TODO: Now that this is asynchronous, can probably get rid of the closure.
                await vm.finalizeSale {
                    /// Once the sale saves successfully, return the cart to its original state.
                    // TODO: This probably won't work for smaller screens. Menu shouldn't be compact.
                    cartState = .sidebar
                    menuState = .compact
                }
            }
        }
        
        if cartState == .confirming {
            withAnimation(.interpolatingSpring) {
                menuState = .closed
            }
        }
    }
    
    var receiptMaxHeight: CGFloat {
        if uiProperties.height < 440 {
            return 300
        } else {
            return 600
        }
    }

    var body: some View {
        VStack(alignment: .center, spacing: cartState == .confirming ? 24 : 0) {
            Text(cartState == .confirming ? "Sale #\(vm.calcNextSaleNumber())" : "Cart")
                .font(cartState == .confirming ? .largeTitle : .title2)
                .fontWeight(.regular)
                .fontDesign(cartState == .confirming ? .rounded : .default)
            
            /// Try to display the cart components horizontally first. If the screen is not wide enough, display them vertically.
            if cartState == .confirming {
                ViewThatFits {
                    // For larger screens
                    HStack {
                        Spacer()
                        confirmationView
                            .padding(.vertical)
//                            .background(Color("bgColor").opacity(cartState == .confirming ? 0.25 : 0.0))
//                            .modifier(GlowingOutlineMod())
                            .frame(minWidth: 320, idealWidth: 360, maxWidth: 420)
                        Spacer()
                        receiptTotalsView
                            .frame(maxWidth: cartState == .confirming ? 420 : uiProperties.width)
                        Spacer()
                    } //: HStack
                    
                    // For smaller screens
                    VStack {
                        confirmationView
                            .background(Color("bgColor"))
//                            .modifier(GlowingOutlineMod())
                        receiptTotalsView
                    } //: VStack
                } //: ViewThatFits
                
            } else {
                /// When the cartState is not confirming, it is either closed or a sidebar which will
                /// always be stacked vertically.
                cartSidebarView
                receiptTotalsView
            }
        } //: VStack
        .padding()
        .background(.ultraThinMaterial)
        .background(Color("bgColor"))
        .opacity(uiProperties.width < 150 ? 0 : 1)
        .onAppear {
            vm.fetchCompany()
        }
    } //: Body
    
    private var confirmationView: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Sales Receipt")
                Spacer()
                Text(Date().formatted(date: .numeric, time: .shortened))
            } //: HStack
            
            Text("\(vm.companyName)")

            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 16) {
                    ForEach(vm.uniqueItems) { item in
                        let itemQty = vm.cartItems.filter { $0._id == item._id }.count
                        let itemSubtotal: Double = Double(itemQty) * item.retailPrice
                        HStack(spacing: 0) {
                            VStack(alignment: .leading) {
                                Text(item.name)
                                Spacer()
                                Text("Qty: \(itemQty)")
                            } //: VStack
                            
                            Spacer()
                            
                            VStack(alignment: .trailing) {
                                Text("\(item.retailPrice.formatAsCurrencyString()) / unit")
                                Spacer()
                                Text(itemSubtotal.formatAsCurrencyString())
                            } //: VStack
                        } //: HStack
                        .padding(.vertical, 8)
                        
                        Divider().opacity(0.4)
                    } //: ForEach
                } //: VStack
                Spacer()
            } //: ScrollView
            .frame(minHeight: 240, maxHeight: receiptMaxHeight)
            Spacer()
        } //: VStack
        .font(.subheadline)
        .padding()
    } //: Confirmation View
    
    private var cartSidebarView: some View {
        ScrollView {
            ForEach(vm.uniqueItems) { item in
                VStack(alignment: .leading, spacing: 24) {
                    HStack {
                        Text(item.name)
                        Spacer()
                       Text(item.retailPrice.formatAsCurrencyString())
                            .font(.subheadline)
                    } //: HStack
                    
                    HStack {
                        Text("x \(vm.cartItems.filter { $0._id == item._id }.count)")
                        
                        Spacer()
                    }
//                    Stepper("x \(vm.cartItems.filter { $0._id == item._id }.count)") {
//                        vm.addItemToCart(item)
//                    } onDecrement: {
//                        vm.removeItemFromCart(item)
//                    }
                } //: VStack

                Divider().opacity(0.6).padding()
            } //: ForEach
            Spacer()
        } //: Scroll
    } //: Cart Sidebar View
    
    private var receiptTotalsView: some View {
        VStack(alignment: cartState == .confirming ? .center : .leading, spacing: 16) {
            VStack(spacing: uiProperties.width * 0.02) {
                
                HStack {
                    Text("Subtotal:")
                    Spacer()
                    Text("\(vm.cartSubtotal.formatAsCurrencyString())")
                } //: HStack
                
                HStack {
                    Text("Tax: (\(vm.taxRate.toPercentageString())%)")
                    Spacer()
                    Text("\(vm.taxAmount.formatAsCurrencyString())")
                } //: HStack
                
                if cartState == .confirming {
                    Divider()
                }
                
                HStack {
                    Text("Total:")
                    Spacer()
                    Text(vm.total.formatAsCurrencyString())
                } //: HStack
                .fontWeight(.semibold)
                
            } //: VStack
            .font(.subheadline)
            .padding(cartState == .confirming ? 16 : 8)
            .background(Color("bgColor"))
            .clipShape(RoundedRectangle(cornerRadius: cartState == .confirming ? 8 : 0))
            
            
            Button {
                continueTapped()
            } label: {
                Spacer()
                Text(cartState == .confirming ? "Confirm Sale" : "Checkout")
                Spacer()
            }
            .modifier(PrimaryButtonMod())
            
            if cartState == .confirming {
                Button {
                    if uiProperties.width < 640 {
                        cartState = .closed
                    } else {
                        cartState = .sidebar
                    }
                } label: {
                    Spacer()
                    Text("Cancel Sale")
                    Spacer()
                }
                .padding(.vertical, 8)
            }
        } //: VStack
    } //: Receipt Totals View
}

#Preview {
    ResponsiveView { props in
        CartView(cartState: .constant(.confirming), menuState: .constant(.compact), uiProperties: props)
            .environment(\.realm, DepartmentEntity.previewRealm)
            .environmentObject(PointOfSaleViewModel())
    }
}


//struct SaleItemRowView: View {
//    enum ViewType { case cart, receipt }
//    @EnvironmentObject var vm: PointOfSaleViewModel
//    
//    @State var item: ItemEntity
//    @State var viewType: ViewType
//    
//    var body: some View {
//
//    }
//}
