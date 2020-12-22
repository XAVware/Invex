//
//  CartItemView.swift
//  InventoryApp
//
//  Created by Ryan Smetana on 12/10/20.
//

import SwiftUI

struct CartItemView: View {
    @StateObject var cart: Cart
    @ObservedObject var cartItem: CartItem
    
    var body: some View {
        
        HStack {
            Text(self.cartItem.name)
                .padding(.leading)
                .font(.system(size: 18, weight: .semibold, design: .rounded))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack(spacing: 0) {
                
                Button(action: {
                    self.cartItem.decreaseQtyInCart()
                    self.cart.updateTotal()
                }) {
                    Image(systemName: "minus.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .foregroundColor(Color.white)
                }
                .buttonStyle(PlainButtonStyle())
                .opacity(self.cart.isEditable ? 1 : 0)
                
                Text("\(self.cartItem.qtyToPurchase)")
                    .padding()
                    .foregroundColor(.white)
                    .frame(width: 60, height: 40, alignment: .center)
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                
                
                Button(action: {
                    self.cartItem.increaseQtyInCart()
                    self.cart.updateTotal()
                }) {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .foregroundColor(Color.white)
                }
                .buttonStyle(PlainButtonStyle())
                .opacity(self.cart.isEditable ? 1 : 0)
                
            } //: HStack - Stepper
            .frame(maxWidth: .infinity)
            
            Text(self.cartItem.subtotalString)
                .padding(.trailing)
                .font(.system(size: 18, weight: .semibold, design: .rounded))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .trailing)
            
        } //: HStack
        .frame(height: 40)
        
    }
}
