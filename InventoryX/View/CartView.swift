

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
                        ActiveReceiptView(cart: self.cart)
                    case true:
                        ConfirmationView(cart: self.cart)
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
            
        } //: Body
    }
}

