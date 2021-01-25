//
//  ConfirmationView.swift
//  ConcessionTracker
//
//  Created by Ryan Smetana on 1/25/21.
//

import SwiftUI

struct ConfirmationView: View {
    @ObservedObject var cart: Cart
    
    var body: some View {
        VStack() {
            Text("Checkout")
                .font(.title3)
            
            Text("Amount Due:  \(self.cart.cartTotalString)")
                .padding(.vertical)
                .font(.system(size: 36, weight: .semibold, design: .rounded))
                .frame(height: 40)
            
            Spacer().frame(height: 30)
            
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
            
            ScrollView {
                ForEach(self.cart.cartItems, id: \.id) { cartItem in
                    HStack {
                        LazyVStack {
                            Text(cartItem.name)
                                .font(.system(size: 18, weight: .semibold, design: .rounded))
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            if cartItem.name != "" {
                                Text(cartItem.subtype)
                                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                        
                        Text("\(cartItem.qtyToPurchase)")
                            .frame(maxWidth: .infinity, maxHeight: 40, alignment: .center)
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                        
                        Text(cartItem.subtotalString)
                            .font(.system(size: 18, weight: .semibold, design: .rounded))
                            .frame(maxWidth: .infinity, alignment: .trailing)
                        
                    } //: HStack
                    .foregroundColor(.white)
                    .frame(height:50)
                    .padding(.horizontal)
                }
            } //: ScrollView - Cart Items
            
            Divider().background(Color.white).padding(.horizontal)
            
            Button(action: {
                self.cart.finishSale()
            }) {
                Text("Confirm Sale")
            } //: Button - Checkout
            .modifier(SaveButtonModifier())
            .cornerRadius(30, corners: self.cart.isConfirmation ? [.allCorners] : [.bottomLeft])
            
            Spacer().frame(height: 30)
        }
        .frame(maxWidth: 500)
    }
}
