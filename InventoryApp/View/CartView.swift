//
//  CartView.swift
//  InventoryApp
//
//  Created by Ryan Smetana on 12/20/20.
//

import SwiftUI

struct CartView: View {
    @ObservedObject var appManager: AppStateManager
    @ObservedObject var cart: Cart
    
    var body: some View {
        
        VStack(spacing: 0) {
            Text("Cart")
                .padding(.vertical, 7)
                .foregroundColor(.white)
                .font(.system(size: 18, weight: .semibold, design: .rounded))
            
            HStack(spacing: 0) {
                Text("Item:")
                    .padding(.horizontal)
                    .foregroundColor(Color.white.opacity(0.8))
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .frame(width: 120, alignment: .leading)
                
                Text("Qty:")
                    .foregroundColor(Color.white.opacity(0.8))
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .frame(width: 120)
                
                Text("Price:")
                    .padding(.horizontal)
                    .foregroundColor(Color.white.opacity(0.8))
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .frame(width: 120, alignment: .trailing)
            }
            
            Divider().background(Color.white).padding(.horizontal)
            
            Spacer().frame(height: 10)
            
            List {
                ForEach(self.cart.cartItems, id: \.id) { cartItem in
                    CartItemView(cart: self.cart, cartItem: cartItem)
                }
                .onDelete(perform: { indexSet in
                    self.cart.removeItem(atOffsets: indexSet)
                })
                .listRowBackground(Color.clear)
                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            }
            .padding(0)
            
            Divider().background(Color.white).padding(.horizontal)
            
            HStack {
                Text("Total: ")
                    .foregroundColor(.white)
                    .font(.system(size: 24, weight: .semibold, design: .rounded))
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(self.cart.cartTotalString)
                    .foregroundColor(.white)
                    .font(.system(size: 24, weight: .semibold, design: .rounded))
                    .frame(width: 150, alignment: .trailing)
            }
            .padding()
            
            Button(action: {
                for item in self.cart.cartItems {
                    print(item.qtyToPurchase)
                }
            }) {
                Text("Checkout")
                    .foregroundColor(.black)
                    .font(.system(size: 24, weight: .semibold, design: .rounded))
            }
            .frame(maxWidth: .infinity, minHeight: 60)
            .background(K.BackgroundGradients.checkoutButton)
        }
        .frame(width: K.Sizes.cartWidth)
        .background(K.BackgroundGradients.cartView)
    }
}
