

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
            .modifier(DetailTextModifier())
            
            Divider().background(Color.white).padding(.horizontal)
            
            Spacer().frame(height: 10)
            
            ScrollView {
                ForEach(self.cart.cartItems, id: \.id) { cartItem in
                    HStack {
                        LazyVStack {
                            Text(cartItem.name)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            if cartItem.name != "" {
                                Text(cartItem.subtype)
                                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                        Text("\(cartItem.qtyToPurchase)")
                            .frame(maxWidth: .infinity, maxHeight: 40, alignment: .center)
                        
                        Text(cartItem.subtotalString)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    } //: HStack
                    .modifier(DetailTextModifier())
                    .frame(height:50)
                } //: ForEach
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
