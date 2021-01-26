

import SwiftUI

struct CartItemView: View {
    @StateObject var cart: Cart
    @ObservedObject var cartItem: CartItem
    
    var body: some View {
        HStack {
            LazyVStack {
                Text(self.cartItem.name)
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                if self.cartItem.name != "" {
                    Text(self.cartItem.subtype)
                        .font(.system(size: 12, weight: .semibold, design: .rounded))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            
            HStack(spacing: 0) {
                
                Button(action: {
                    self.cartItem.decreaseQtyInCart()
                    self.cart.updateTotal()
                }) {
                    Image(systemName: "minus.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                }
                .buttonStyle(PlainButtonStyle())
                .opacity(self.cart.isConfirmation ? 0 : 1)
                
                Text("\(self.cartItem.qtyToPurchase)")
                    .padding()
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
                }
                .buttonStyle(PlainButtonStyle())
                .opacity(self.cart.isConfirmation ? 0 : 1)
                
            } //: HStack - Stepper
            .frame(maxWidth: .infinity)
            
            Text(self.cartItem.subtotalString)
                .font(.system(size: 18, weight: .semibold, design: .rounded))
                .frame(maxWidth: .infinity, alignment: .trailing)
            
        } //: HStack
        .frame(height: self.cartItem.subtype == "" ? 40 : 50)
        .foregroundColor(Color.white)
    }
}
