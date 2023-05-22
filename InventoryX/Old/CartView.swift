

import SwiftUI

struct CartView: View {
    @ObservedObject var cart: Cart
    
    var body: some View {
        GeometryReader { geometry in
            HStack {
                Spacer(minLength: 0)
                VStack(spacing: 16) {
                    switch self.cart.isConfirmation {
                    case false:
                        activeReceiptView
                    case true:
                        confirmationView
                    }
                } //: VStack
                .foregroundColor(.white)
                .frame(width: self.cart.isConfirmation ? geometry.size.width : geometry.size.width * 0.40, height: geometry.size.height)
                .background(
                    LinearGradient(gradient: Gradient(colors: [Color("CartBackgroundDark"), Color("CartBackgroundLight")]), startPoint: .topLeading, endPoint: .bottomTrailing)
                        .cornerRadius(self.cart.isConfirmation ? 0 : 30, corners: [.topLeft, .bottomLeft])
                        .edgesIgnoringSafeArea(.all)
                        .shadow(color: .black, radius: 10, x: 0, y: 0)
                )
                .animation(.linear(duration: 0.5), value: true)
                .transition(.asymmetric(insertion: .opacity, removal: .opacity))
                .overlay(
                    Button(action: {
                        withAnimation {
                            self.cart.isConfirmation = false
                        }
                    }) {
                        HStack(spacing: 3) {
                            Image(systemName: "chevron.left")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 15, height: 20, alignment: .center)
                            
                            Text("Go Back")
                        }
                        
                    }
                    .foregroundColor(.white)
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .frame(width: 100)
                    .padding()
                    .opacity(self.cart.isConfirmation ? 1 : 0)
                    , alignment: .topLeading)
            }
            
        }
    } //: Body
    
    private var activeReceiptView: some View {
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
                .modifier(DetailTextModifier())
                
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
                    
                    guard !self.cart.cartItems.isEmpty else { return }
                    
                    withAnimation { self.cart.isConfirmation = true }
                    
                }) {
                    Text("Checkout")
                } //: Button - Checkout
                .font(.system(size: 24, weight: .semibold, design: .rounded))
                .frame(maxWidth: 500, minHeight: 60)
                .background(Color("GreenBackground"))
                .cornerRadius(30, corners: self.cart.isConfirmation ? [.allCorners] : [.bottomLeft])
            } //: VStack
            .frame(maxWidth: 500)
        } //: VStack
    } //: Active Receipt View
    
    private var confirmationView: some View {
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
            .font(.system(size: 24, weight: .semibold, design: .rounded))
            .frame(maxWidth: 500, minHeight: 60)
            .background(Color("GreenBackground"))
            .cornerRadius(30, corners: self.cart.isConfirmation ? [.allCorners] : [.bottomLeft])
            
            Spacer().frame(height: 30)
        }
        .frame(maxWidth: 500)
    } //: Confirmation View
}

