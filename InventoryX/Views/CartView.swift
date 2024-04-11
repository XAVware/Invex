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
            return 280
        case .confirming:
            return .infinity
        }
    }
}

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
            vm.finalizeSale {
                /// Once the sale saves successfully, return the cart to its original state.
                cartState = .sidebar
                menuState = .compact
            }
        }
        
        if cartState == .confirming {
            withAnimation(.interpolatingSpring) {
                menuState = .closed
            }
        }
        print("Cart width is now: \(uiProperties.width)")
    }
    
//    var columns: [GridItem] {
//        var colCount = 1
//        if uiProperties.width > 600 {
//            colCount = 2
//        }
//        return Array(repeating: GridItem(.flexible(minimum: 300, maximum: .infinity), spacing: 16), count: colCount)
//    }
    
    var body: some View {
        VStack(alignment: .center, spacing: cartState == .confirming ? 24 : 0) {
            Text(cartState == .confirming ? "Order Summary" : "Cart")
                .font(cartState == .confirming ? .largeTitle : .title2)
                .fontWeight(cartState == .confirming ? .bold : .regular)
                .fontDesign(cartState == .confirming ? .rounded : .default)
            
            if cartState == .confirming {
                ViewThatFits {
                    // For larger screens
                    HStack {
                        Spacer()
                        confirmationView
                            .frame(minWidth: 320, idealWidth: 420, maxWidth: 480)
                        Spacer()
                        receiptTotalsView
                            .frame(maxWidth: cartState == .confirming ? 420 : uiProperties.width)
                        Spacer()
                    } //: HStack
                    
                    // For smaller screens
                    VStack {
                        confirmationView
                        receiptTotalsView
                    } //: VStack
                } //: ViewThatFits
            } else {
                cartSidebarView
                receiptTotalsView
            }
            
            //            LazyVGrid(columns: columns) {
            //
            //                if cartState == .confirming {
            //                    confirmationView
            //                } else {
            //                    GeometryReader { geo in
            //                        cartSidebarView
            //                            .frame(height: 800)
            //                    }
            ////                        .frame(maxWidth: uiProperties.width, idealHeight: uiProperties.height * 0.7, maxHeight: 800)
            //                        .environmentObject(vm)
            //                }
            //                
            //                receiptTotalsView
            //            } //: Lazy V Grid
            //            .frame(width: uiProperties.width, height: uiProperties.height)
        } //: VStack
        .opacity(uiProperties.width < 150 ? 0 : 1)
        
    } //: Body
    
    private var confirmationView: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Sale #123456")
                        .font(.headline)
                    Text("Company Name")
                        .font(.subheadline)
                } //: VStack
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 6) {
                    Text(Date().formatted(date: .long, time: .omitted))
                    Text(Date().formatted(date: .omitted, time: .shortened))
                } //: VStack
            } //: HStack
            
            Text("Receipt: (\(vm.cartItemCount) Items)")
                .font(.title3)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical)
            //                HStack {
            //                    Text("Item")
            //                    Spacer()
            //                    Text("Price")
            //                    Spacer()
            //                    Text("Subtotal")
            //                } //: HStack
            //                .font(.callout)
            //                .foregroundStyle(.black)
            
            //                Divider().opacity(0.4)
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 16) {
                    ForEach(vm.uniqueItems) { item in
                        let itemQty = vm.cartItems.filter { $0._id == item._id }.count
                        let itemSubtotal: Double = Double(itemQty) * item.retailPrice
                        HStack(spacing: 0) {
                            VStack(alignment: .leading) {
                                Text(item.name)
                                    .font(.headline)
                                Spacer()
                                Text("Qty: \(itemQty)")
                                    .font(.subheadline)
                            } //: VStack
                            
                            Spacer()
                            
                            VStack(alignment: .trailing) {
                                Text("\(item.retailPrice.formatAsCurrencyString()) / unit")
                                    .font(.caption)
                                Spacer()
                                Text(itemSubtotal.formatAsCurrencyString())
                                    .font(.subheadline)
                            } //: VStack
                        } //: HStack
                        .foregroundStyle(.black)
                        .padding(.vertical, 8)
                        
                        Divider().opacity(0.4)
                    } //: ForEach
                } //: VStack
                Spacer()
            } //: ScrollView
            .frame(minHeight: 400, idealHeight: uiProperties.height * 0.65, maxHeight: 600)
            Spacer()
        } //: VStack
        .padding()
        .background(.white.opacity(0.6))
        .modifier(GlowingOutlineMod())
    } //: Confirmation View
    
    private var cartSidebarView: some View {
        ScrollView {
            ForEach(vm.uniqueItems) { item in
                SaleItemRowView(item: item, viewType: .cart)
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
            .padding(cartState == .confirming ? 16 : 8)
            .background(Color("Purple050").opacity(cartState == .confirming ? 0.25 : 0.0))
            .clipShape(RoundedRectangle(cornerRadius: cartState == .confirming ? 8 : 0))
            
            
            Button {
                continueTapped()
            } label: {
                Spacer()
                Text("Checkout")
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
            }
        } //: VStack
    } //: Receipt Totals View
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
