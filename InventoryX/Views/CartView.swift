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
    
    @State var origWidth: CGFloat = 0
    
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
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                Text(cartState == .confirming ? "Order Summary" : "Cart")
                    .font(cartState == .confirming ? .largeTitle : .title2)
                
                
                if cartState == .confirming {
                    // MARK: - CONFIRMATION VIEW
                    VStack {
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
                        .padding(.vertical, 16)
                        .padding(.bottom, 16)
                        
                        HStack {
                            Text("Item")
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
    //                        Text("Quantity")
    //                            .frame(maxWidth: .infinity)
                            
                            Text("Price")
                                .frame(maxWidth: .infinity)
                            
                            Text("Subtotal")
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        } //: HStack
                        .font(.callout)
                        .foregroundStyle(.black)
                        
                        Divider()
                        
                        ScrollView(.vertical, showsIndicators: false) {
                            VStack {
                                ForEach(vm.cartItems, id: \.id) { item in
                                    HStack {
                                        VStack(alignment: .leading) {
                                            Text(item.name ?? "Error")
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                            
                                            Text("Qty: \(item.qtyInCart ?? -1)")
    //                                            .frame(maxWidth: .infinity)
                                        }
                                        Text(item.retailPrice?.formatAsCurrencyString() ?? "Error")
                                            .frame(maxWidth: .infinity)
                                        
                                        Text(item.cartItemSubtotal.formatAsCurrencyString())
                                            .frame(maxWidth: .infinity, alignment: .trailing)
                                    } //: HStack
                                    .font(.callout)
    //                                .fontWeight(.semibold)
                                    .foregroundStyle(.black)
                                    .frame(height: 30)
                                    .padding(.vertical, 12)
                                    
                                    Divider()
                                } //: ForEach
                            } //: VStack
                        } //: ScrollView
                    } //: VStack
                    
                    .frame(maxWidth: 420)
                    .padding()
                    .background(.white.opacity(0.3))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    
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
                                

                                    HStack(spacing: 0) {
                                        Button {
                                            item.qtyInCart? -= 1
                                        } label: {
                                            Image(systemName: "minus")
                                                .resizable()
                                                .scaledToFit()
                                                .padding(6)
                                                .frame(width: 24, height: 24)
                                        }
                                        
                                        Divider()
                                        
                                        Text("\(item.qtyInCart ?? -1)")
                                            .font(.subheadline)
                                            .frame(width: 36)
                                        
                                        Divider()
                                        
                                        Button {
                                            item.qtyInCart? += 1
                                        } label: {
                                            Image(systemName: "plus")
                                                .resizable()
                                                .scaledToFit()
                                                .padding(6)
                                                .frame(width: 24, height: 24)
                                        }
                                        
                                    } //: HStack
                                    .background(Color("Purple050").opacity(0.5))
                                    .background(.ultraThinMaterial)
                                    .frame(height: 24)
                                    .clipShape(RoundedRectangle(cornerRadius: 6))
                                    
                                
                            } //: VStack
                            .frame(maxWidth: 350, maxHeight: 72, alignment: .leading)
                            
                            Divider().opacity(0.6).padding()
                        } //: For Each
                        Spacer()
                    } //: VStack
                    .padding(.vertical)
                    .frame(maxHeight: .infinity)
                    
                }
                
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
                    
                    Divider()
                    
                    HStack {
                        Text("Total:")
                        Spacer()
                        Text((cartSubtotal + taxAmount).formatAsCurrencyString())
                    } //: HStack
                    .font(cartState == .confirming ? .title2 : .subheadline)
                    .fontWeight(.semibold)
                    .padding(.vertical, 8)
                    
                } //: VStack
                .padding()
                .frame(maxWidth: 420)
                .background(Color("Purple050").opacity(0.8))
                .clipShape(RoundedRectangle(cornerRadius: 8))
                
                Button {
                    continueTapped()
                } label: {
                    Text("Checkout")
                }
                .modifier(PrimaryButtonMod())
            } //: VStack
            .onAppear {
                origWidth = geo.size.width
            }
        } //: Geometry Reader
    } //: Body
    
    
}

//#Preview {
//    CartViewNew(cartState: .constant(.sidebar), menuState: .constant(.open))
//        .environmentObject(MakeASaleViewModel())
//    
//}

#Preview {
    ResponsiveView { props in
        RootView(uiProperties: props)
            .environment(\.realm, DepartmentEntity.previewRealm)
    }
}
