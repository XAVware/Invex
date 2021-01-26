//
//  ActiveReceiptView.swift
//  ConcessionTracker
//
//  Created by Ryan Smetana on 1/25/21.
//

import SwiftUI

struct ActiveReceiptView: View {
    @ObservedObject var cart: Cart
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Cart")
                .font(.title3)
            
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    Text("Item:")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text("Qty:")
                        .frame(maxWidth: .infinity)
                    
                    Text("Price:")
                        .frame(maxWidth: .infinity, alignment: .trailing)
                } //: HStack - Column Titles
                .modifier(ListHeaderModifier())
                
                Divider().background(Color.white).padding(.horizontal)
                
                Spacer().frame(height: 10)
                
                //MARK: - Cart Items List
                List {
                    ForEach(self.cart.cartItems, id: \.id) { cartItem in
                        CartItemView(cart: self.cart, cartItem: cartItem)
                    }
                    .onDelete(perform: { indexSet in
                        self.cart.removeItem(atOffsets: indexSet)
                    })
                    
                    .listRowBackground(Color.clear)
                } //: ScrollView - Cart Items
                
                Divider().background(Color.white).padding(.horizontal)
                
                HStack {
                    Text("Total: ")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text(self.cart.cartTotalString)
                        .frame(width: 150, alignment: .trailing)
                } //: HStack - Cart Total
                .padding()
                .font(.system(size: 24, weight: .semibold, design: .rounded))
                .frame(height: 60)
                
                Button(action: {
                    var currentIndex = 0
                    for cartItem in self.cart.cartItems {
                        if cartItem.qtyToPurchase == 0 {
                            self.cart.cartItems.remove(at: currentIndex)
                        }
                        currentIndex += 1
                    }
                    
                    guard !self.cart.cartItems.isEmpty else {
                        return
                    }
                    
                    withAnimation { self.cart.isConfirmation = true }
                    
                }) {
                    Text("Checkout")
                } //: Button - Checkout
                .modifier(SaveButtonModifier())
                .cornerRadius(30, corners: self.cart.isConfirmation ? [.allCorners] : [.bottomLeft])
            } //: VStack
            .frame(maxWidth: 500)
        }
    }
}
