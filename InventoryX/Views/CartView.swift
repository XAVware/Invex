//
//  CartView.swift
//  InventoryX
//
//  Created by Ryan Smetana on 3/19/24.
//

import SwiftUI

enum CartState {
    case hidden
    case sidebar
    case confirming
}

struct CartView: View {
    
    @EnvironmentObject var vm: MakeASaleViewModel
    
    @Binding var cartState: CartState
    @Binding var menuState: MenuState
    
    //    @State var origWidth: CGFloat = 0
    
    let uiProperties: LayoutProperties
    
    var cartSubtotal: Double {
        return vm.cartItems.reduce(0) {
            guard let qty = $1.qtyInCart, let price = $1.retailPrice else { return -1 }
            return $0 + Double(qty) * price
        }
    }
    
    var taxAmount: Double { cartSubtotal * 0.07 }
    
    func continueTapped() {
        switch cartState {
        case .hidden:
            return
        case .sidebar:
            //Remove items from cart if the quantity is 0 and check that there are still items in cart.
            vm.cartItems.removeAll (where: { $0.qtyInCart == 0 })
            guard !vm.cartItems.isEmpty else { return }
            
            cartState = .confirming
            
        case .confirming:
            vm.finalizeSale {
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
        VStack(alignment: .center) {
            Text(cartState == .confirming ? "Order Summary" : "Cart")
                .font(cartState == .confirming ? .largeTitle : .title2)
                .fontWeight(cartState == .confirming ? .bold : .regular)
                .fontDesign(cartState == .confirming ? .rounded : .default)
            
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
                                ForEach(vm.cartItems, id: \.id) { item in
                                    HStack {
                                        VStack(alignment: .leading) {
                                            Text(item.name ?? "Error")
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                            
                                            Text("Qty: \(item.qtyInCart ?? -1)")
                                        }
                                        Text(item.retailPrice?.formatAsCurrencyString() ?? "Error")
                                            .frame(maxWidth: .infinity)
                                        
                                        Text(item.cartItemSubtotal.formatAsCurrencyString())
                                            .frame(maxWidth: .infinity, alignment: .trailing)
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
                        ForEach(vm.cartItems, id: \.id) { item in
                            VStack(alignment: .leading, spacing: 24) {
                                HStack {
                                    Text(item.name ?? "Empty")
                                        .font(.subheadline)
                                    Spacer()
                                    
                                    Text((item.retailPrice ?? -5).formatAsCurrencyString())
                                        .font(.subheadline)
                                } //: HStack
                                
                                if let qty = item.qtyInCart {
                                    Stepper("x \(qty)") {
                                        item.qtyInCart? += 1
                                    } onDecrement: {
                                        item.qtyInCart? -= 1
                                    }
                                    .frame(maxWidth: uiProperties.width)
                                }
                            } //: VStack
                            
                            Divider().opacity(0.6).padding()
                        } //: For Each
                        Spacer()
                    } //: Scroll
                    .frame(maxWidth: uiProperties.width)
                    .frame(height: uiProperties.height * 0.65)
                    Spacer()
                }
                
                
                // ITEM 2
                VStack(alignment: cartState == .confirming ? .center : .leading, spacing: 16) {
                    VStack(spacing: 16) {
                        
                        HStack {
                            Text("Subtotal:")
                            
                            Spacer()
                            Text(cartSubtotal.formatAsCurrencyString())
                        } //: HStack
                        .font(cartState == .confirming ? .title3 : .subheadline)
                        .fontWeight(.regular)
                        
                        HStack {
                            Text("Tax:")
                            Spacer()
                            Text("\(taxAmount.formatAsCurrencyString())")
                        } //: HStack
                        .font(cartState == .confirming ? .title3 : .subheadline)
                        .fontWeight(.regular)
                        
                        if cartState == .confirming {
                            Divider()
                        }
                        
                        HStack {
                            Text("Total:")
                            Spacer()
                            Text((cartSubtotal + taxAmount).formatAsCurrencyString())
                        } //: HStack
                        .font(cartState == .confirming ? .title2 : .subheadline)
                        .fontWeight(.semibold)
                        .padding(.vertical, 8)
                        
                    } //: VStack
                    .padding(cartState == .confirming ? 16 : 2)
                    .frame(maxWidth: cartState == .confirming ? 420 : uiProperties.width)
                    .background(Color("Purple050").opacity(cartState == .confirming ? 0.8 : 0.0))
                    .clipShape(RoundedRectangle(cornerRadius: cartState == .confirming ? 8 : 0))
                    
                    Button {
                        continueTapped()
                    } label: {
                        Text("Checkout")
                    }
                    .modifier(PrimaryButtonMod())
                    .frame(height: 48)
                    .frame(maxWidth: uiProperties.width)
                    .padding(.bottom)
                } //: VStack
                .frame(height: uiProperties.height * 0.25)
            } //: Lazy V Grid
            .frame(width: uiProperties.width, height: uiProperties.height)
        } //: VStack
        
    } //: Body
    
    
}

//#Preview {
//    CartView(cartState: .constant(.confirming), menuState: .constant(.open))
//        .environmentObject(MakeASaleViewModel())
//
//}


#Preview {
    ResponsiveView { props in
        RootView(uiProperties: props)
            .environment(\.realm, DepartmentEntity.previewRealm)
    }
}
