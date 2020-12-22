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
            Text(cartItem.name)
                .padding(.leading)
                .font(.system(size: 18, weight: .semibold, design: .rounded))
                .foregroundColor(.white)
                .frame(width: (K.Sizes.cartWidth / 3), alignment: .leading)
            
            HStack(spacing: 0) {
                Button(action: {
                    if cartItem.qtyToPurchase != 0 {
                        self.cart.decreaseQuantity(forItem: self.cartItem)
                    }
                }) {
                    Image(systemName: "minus.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .foregroundColor(Color.white)
                }
                .buttonStyle(PlainButtonStyle())
                
                Text("\(self.cartItem.qtyToPurchase)")
                    .padding()
                    .foregroundColor(.white)
                    .frame(minWidth: 40, idealWidth: 50, maxWidth: 60, minHeight: 40, idealHeight: 40, maxHeight: 40, alignment: .center)
                    .multilineTextAlignment(.center)
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                
                
                Button(action: {
                    if cartItem.qtyToPurchase < 24 {
                        self.cart.increaseQuantity(forItem: self.cartItem)
                    }
                }) {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .foregroundColor(Color.white)
                }
                .buttonStyle(PlainButtonStyle())
            } //: HStack - Stepper
            .frame(maxWidth: .infinity)
            
            Text("$ \(self.cartItem.retailPrice)")
                .padding(.trailing)
                .font(.system(size: 18, weight: .semibold, design: .rounded))
                .foregroundColor(.white)
                .frame(width: (K.Sizes.cartWidth / 3), alignment: .trailing)
        }
        .frame(height: 40)
        
    }
}
