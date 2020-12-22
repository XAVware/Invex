//
//  CartView.swift
//  InventoryApp
//
//  Created by Ryan Smetana on 12/20/20.
//

import SwiftUI

struct CartView: View {
    @ObservedObject var cart: Cart
    
    var body: some View {
        
        HStack(spacing: 0) {
            
            Spacer().frame(width: !self.cart.isEditable ? 0 : UIScreen.main.bounds.width - K.Sizes.cartWidth)
            
            //MARK: Cart Stack
            VStack(spacing: 0) {
                
                if self.cart.isEditable {
                    Text("Cart")
                        .padding(.vertical)
                        .foregroundColor(.white)
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                        .frame(width: K.Sizes.cartWidth)
                } else {
                    HStack(spacing: 0) {
                        Button(action: {
                            withAnimation {
                                self.cart.isEditable = true
                            }
                        }) {
                            HStack(spacing: 2) {
                                Image(systemName: "chevron.left")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 15, height: 20, alignment: .center)
                                    .accentColor(.white)
                                
                                Text("Go Back")
                                    .foregroundColor(.white)
                                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                            }
                                
                        }
                        .frame(width: 100)
                        .padding()
                        
                        Text("Checkout")
                            .padding(.vertical)
                            .foregroundColor(.white)
                            .font(.system(size: 18, weight: .semibold, design: .rounded))
                            .frame(maxWidth: .infinity)
                        
                        Spacer().frame(width: 100).padding()
                        
                    }
                }
                
                
                Text("Amount Due:  \(self.cart.cartTotalString)")
                    .padding(.vertical)
                    .foregroundColor(.white)
                    .font(.system(size: 36, weight: .semibold, design: .rounded))
                    .frame(height: !self.cart.isEditable ? 40 : 0)
                    .opacity(!self.cart.isEditable ? 1.00 : 0.00)
                
                Spacer().frame(height: !self.cart.isEditable ? 40 : 2)
                
                //MARK: - Receipt Stack
                VStack(spacing: 0) {
                    HStack(spacing: 0) {
                        Text("Item:")
                            .padding(.horizontal)
                            .foregroundColor(Color.white.opacity(0.8))
                            .font(.system(size: 18, weight: .semibold, design: .rounded))
                            .frame(maxWidth: .infinity, alignment: .leading)

                        Text("Qty:")
                            .foregroundColor(Color.white.opacity(0.8))
                            .font(.system(size: 18, weight: .semibold, design: .rounded))
                            .frame(maxWidth: .infinity)

                        Text("Price:")
                            .padding(.horizontal)
                            .foregroundColor(Color.white.opacity(0.8))
                            .font(.system(size: 18, weight: .semibold, design: .rounded))
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    } //: HStack - Column Titles
                    
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
                        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    } //: List - Cart Items
                    .padding(0)
                    
                    Divider().background(Color.white).padding(.horizontal)
                    
                    
                    //MARK: - Cart Total Stack
                    HStack {
                        Text("Total: ")
                            .foregroundColor(.white)
                            .font(.system(size: 24, weight: .semibold, design: .rounded))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text(self.cart.cartTotalString)
                            .foregroundColor(.white)
                            .font(.system(size: 24, weight: .semibold, design: .rounded))
                            .frame(width: 150, alignment: .trailing)
                    } //: HStack - Cart Total
                    .frame(height: !self.cart.isEditable ? 50 : 30)
                    .padding()
                    .opacity(!self.cart.isEditable ? 0 : 1)
                    
                    
                } //: VStack - Receipt Stack
                .frame(maxWidth: !self.cart.isEditable ? 600 : K.Sizes.cartWidth)
                
                //MARK: - Checkout Button
                Button(action: {
                    if self.cart.isEditable {
                        withAnimation {
                            self.cart.isEditable = false
                        }
                    } else {
                        self.cart.finishSale()
                    }
                }) {
                    Text(!self.cart.isEditable ? "Confirm Sale" : "Checkout")
                        .foregroundColor(.white)
                        .font(.system(size: 24, weight: .semibold, design: .rounded))
                } //: Button - Checkout
                .frame(maxWidth: 500, minHeight: 60)
                .background(K.BackgroundGradients.greenButton)
                .cornerRadius(!self.cart.isEditable ? 15 : 0)
                
                Spacer().frame(height: !self.cart.isEditable ? 70 : 0)
                
            } //: VStack - Cart Stack
            .frame(width: !self.cart.isEditable ? UIScreen.main.bounds.width : K.Sizes.cartWidth)
            .background(K.BackgroundGradients.cartView).edgesIgnoringSafeArea(.all)
        } //: HStack
        .frame(width: UIScreen.main.bounds.width, height: !self.cart.isEditable ? UIScreen.main.bounds.height - K.SafeAreas.top! : UIScreen.main.bounds.height - K.Sizes.headerHeight - K.SafeAreas.top!)
        .offset(x: 0, y: !self.cart.isEditable ? -(K.Sizes.headerHeight) : 0)
    } //: Body
}
