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
        VStack(spacing: 5) {
            HStack {
                Text(cartItem.name)
                    .padding(.leading)
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
                    .frame(width: 120, alignment: .leading)
                
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
                            .accentColor(Color.white)
                    }
                    
                    Text("\(self.cartItem.qtyToPurchase)")
                        .padding()
                        .foregroundColor(.white)
                        .frame(minWidth: 40, idealWidth: 50, maxWidth: 60, minHeight: 40, idealHeight: 40, maxHeight: 40, alignment: .center)
//                        .frame(width: 50, height: 40, alignment: .center)
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
                            .accentColor(Color.white)
                    }
                } //: HStack - Stepper
                
                Text("$ \(self.cartItem.retailPrice)")
                    .padding(.trailing)
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
                    .frame(width: 120, alignment: .trailing)
            }
            Divider().background(Color.white).padding(.horizontal)
        }
        .frame(width: 360, height: 40)
        .background(Color.clear)
    }
}

//struct CartItemView_Previews: PreviewProvider {
//    static var previews: some View {
//        CartItemView()
//            .previewLayout(.sizeThatFits)
//    }
//}
