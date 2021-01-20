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
        GeometryReader { geometry in
            ZStack(alignment: self.cart.isConfirmation ? .center : .leading) {
                K.Backgrounds.cartView
                    .cornerRadius(self.cart.isConfirmation ? 0 : 30, corners: [.topLeft, .bottomLeft])
                    .edgesIgnoringSafeArea(.all)
                    .shadow(color: .black, radius: 10, x: 0, y: 0)
                    .frame(width: geometry.size.width)
                
                VStack(spacing: 0) {
                    
                    if self.cart.isConfirmation {
                        HStack(spacing: 0) {
                            Button(action: {
                                withAnimation {
                                    self.cart.isConfirmation = false
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
                    } else {
                        Text("Cart")
                            .padding(.vertical)
                            .foregroundColor(.white)
                            .font(.system(size: 18, weight: .semibold, design: .rounded))
                            .frame(width: K.Sizes.cartWidth)
                        
                    }
                    
                    
                    Text("Amount Due:  \(self.cart.cartTotalString)")
                        .padding(.vertical)
                        .foregroundColor(.white)
                        .font(.system(size: 36, weight: .semibold, design: .rounded))
                        .frame(height: self.cart.isConfirmation ? 40 : 0)
                        .opacity(self.cart.isConfirmation ? 1.00 : 0.00)
                    
                    Spacer().frame(height: self.cart.isConfirmation ? 40 : 2)
                    
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
                        .frame(height: self.cart.isConfirmation ? 50 : 30)
                        .padding()
                        .opacity(self.cart.isConfirmation ? 0 : 1)
                        
                        //MARK: - Checkout Button
                        Button(action: {
                            if !self.cart.isConfirmation {
                                var currentIndex = 0
                                for cartItem in self.cart.cartItems {
                                    if cartItem.qtyToPurchase == 0 {
                                        self.cart.cartItems.remove(at: currentIndex)
                                    }
                                    currentIndex += 1
                                }
                                
                                guard !self.cart.cartItems.isEmpty else {
                                    return
                                }
                                
                                withAnimation {
                                    self.cart.isConfirmation = true
                                }
                                
                            } else {
                                self.cart.finishSale()
                            }
                        }) {
                            Text(self.cart.isConfirmation ? "Confirm Sale" : "Checkout")
                                .foregroundColor(.white)
                                .font(.system(size: 24, weight: .semibold, design: .rounded))
                        } //: Button - Checkout
                        .frame(maxWidth: 500, minHeight: 60)
                        .background(K.Backgrounds.greenButton)
                        .cornerRadius(30, corners: self.cart.isConfirmation ? [.allCorners] : [.bottomLeft])
                        
                    } //: VStack - Receipt Stack
                    .frame(maxWidth: K.Sizes.cartWidth)
                    
                    
                    
//                    Spacer().frame(height: self.cart.isConfirmation ? 70 : 0)
                    
                }
            } //: ZStack
            .offset(x: self.cart.isConfirmation ? 0 : geometry.size.width - K.Sizes.cartWidth, y: 0)
            
            
            
//            //MARK: Cart Stack
//            VStack(alignment: .leading, spacing: 0) {
//
//                if self.cart.isConfirmation {
//                    HStack(spacing: 0) {
//                        Button(action: {
//                            withAnimation {
//                                self.cart.isConfirmation = false
//                            }
//                        }) {
//                            HStack(spacing: 2) {
//                                Image(systemName: "chevron.left")
//                                    .resizable()
//                                    .scaledToFit()
//                                    .frame(width: 15, height: 20, alignment: .center)
//                                    .accentColor(.white)
//
//                                Text("Go Back")
//                                    .foregroundColor(.white)
//                                    .font(.system(size: 18, weight: .semibold, design: .rounded))
//                            }
//
//                        }
//                        .frame(width: 100)
//                        .padding()
//
//                        Text("Checkout")
//                            .padding(.vertical)
//                            .foregroundColor(.white)
//                            .font(.system(size: 18, weight: .semibold, design: .rounded))
//                            .frame(maxWidth: .infinity)
//
//                        Spacer().frame(width: 100).padding()
//
//                    }
//                } else {
//                    Text("Cart")
//                        .padding(.vertical)
//                        .foregroundColor(.white)
//                        .font(.system(size: 18, weight: .semibold, design: .rounded))
//                        .frame(width: K.Sizes.cartWidth)
//
//                }
//
//
//                Text("Amount Due:  \(self.cart.cartTotalString)")
//                    .padding(.vertical)
//                    .foregroundColor(.white)
//                    .font(.system(size: 36, weight: .semibold, design: .rounded))
//                    .frame(height: self.cart.isConfirmation ? 40 : 0)
//                    .opacity(self.cart.isConfirmation ? 1.00 : 0.00)
//
//                Spacer().frame(height: self.cart.isConfirmation ? 40 : 2)
//
//                //MARK: - Receipt Stack
//                VStack(alignment: .leading, spacing: 0) {
//                    HStack(spacing: 0) {
//                        Text("Item:")
//                            .padding(.horizontal)
//                            .foregroundColor(Color.white.opacity(0.8))
//                            .font(.system(size: 18, weight: .semibold, design: .rounded))
//                            .frame(maxWidth: .infinity, alignment: .leading)
//
//                        Text("Qty:")
//                            .foregroundColor(Color.white.opacity(0.8))
//                            .font(.system(size: 18, weight: .semibold, design: .rounded))
//                            .frame(maxWidth: .infinity)
//
//                        Text("Price:")
//                            .padding(.horizontal)
//                            .foregroundColor(Color.white.opacity(0.8))
//                            .font(.system(size: 18, weight: .semibold, design: .rounded))
//                            .frame(maxWidth: .infinity, alignment: .trailing)
//                    } //: HStack - Column Titles
//
//                    Divider().background(Color.white).padding(.horizontal)
//
//                    Spacer().frame(height: 10)
//
//                    //MARK: - Cart Items List
//                    List {
//                        ForEach(self.cart.cartItems, id: \.id) { cartItem in
//                            CartItemView(cart: self.cart, cartItem: cartItem)
//                        }
//                        .onDelete(perform: { indexSet in
//                            self.cart.removeItem(atOffsets: indexSet)
//                        })
//                        .listRowBackground(Color.clear)
//                        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
//                    } //: List - Cart Items
//                    .padding(0)
//
//                    Divider().background(Color.white).padding(.horizontal)
//
//
//                    //MARK: - Cart Total Stack
//                    HStack {
//                        Text("Total: ")
//                            .foregroundColor(.white)
//                            .font(.system(size: 24, weight: .semibold, design: .rounded))
//                            .frame(maxWidth: .infinity, alignment: .leading)
//
//                        Text(self.cart.cartTotalString)
//                            .foregroundColor(.white)
//                            .font(.system(size: 24, weight: .semibold, design: .rounded))
//                            .frame(width: 150, alignment: .trailing)
//                    } //: HStack - Cart Total
//                    .frame(height: self.cart.isConfirmation ? 50 : 30)
//                    .padding()
//                    .opacity(self.cart.isConfirmation ? 0 : 1)
//
//
//                } //: VStack - Receipt Stack
//                .frame(maxWidth: K.Sizes.cartWidth)
//
//                //MARK: - Checkout Button
//                Button(action: {
//                    if !self.cart.isConfirmation {
//                        withAnimation {
//                            self.cart.isConfirmation = true
//                        }
//                    } else {
//                        self.cart.finishSale()
//                    }
//                }) {
//                    Text(self.cart.isConfirmation ? "Confirm Sale" : "Checkout")
//                        .foregroundColor(.white)
//                        .font(.system(size: 24, weight: .semibold, design: .rounded))
//                } //: Button - Checkout
//                .frame(maxWidth: 500, minHeight: 60)
//                .background(K.Backgrounds.greenButton)
//                .cornerRadius(30, corners: self.cart.isConfirmation ? [.allCorners] : [.bottomLeft])
//
//                Spacer().frame(height: self.cart.isConfirmation ? 70 : 0)
//
//            } //: VStack - Cart Stack
//            .frame(width: geometry.size.width)
//            .background(
//                K.Backgrounds.cartView
//                    .cornerRadius(self.cart.isConfirmation ? 0 : 30, corners: [.topLeft, .bottomLeft])
//                    .edgesIgnoringSafeArea(.all)
//                    .shadow(color: .black, radius: 10, x: 0, y: 0)
//            )
//        }
        
            
    
        
        
//        HStack(spacing: 0) {
//
//            Spacer().frame(width: self.cart.isConfirmation ? 0 : UIScreen.main.bounds.width - K.Sizes.cartWidth)
//
//            //MARK: Cart Stack
//            VStack(spacing: 0) {
//
//                if self.cart.isConfirmation {
//                    HStack(spacing: 0) {
//                        Button(action: {
//                            withAnimation {
//                                self.cart.isConfirmation = false
//                            }
//                        }) {
//                            HStack(spacing: 2) {
//                                Image(systemName: "chevron.left")
//                                    .resizable()
//                                    .scaledToFit()
//                                    .frame(width: 15, height: 20, alignment: .center)
//                                    .accentColor(.white)
//
//                                Text("Go Back")
//                                    .foregroundColor(.white)
//                                    .font(.system(size: 18, weight: .semibold, design: .rounded))
//                            }
//
//                        }
//                        .frame(width: 100)
//                        .padding()
//
//                        Text("Checkout")
//                            .padding(.vertical)
//                            .foregroundColor(.white)
//                            .font(.system(size: 18, weight: .semibold, design: .rounded))
//                            .frame(maxWidth: .infinity)
//
//                        Spacer().frame(width: 100).padding()
//
//                    }
//                } else {
//                    Text("Cart")
//                        .padding(.vertical)
//                        .foregroundColor(.white)
//                        .font(.system(size: 18, weight: .semibold, design: .rounded))
//                        .frame(width: K.Sizes.cartWidth)
//
//                }
//
//
//                Text("Amount Due:  \(self.cart.cartTotalString)")
//                    .padding(.vertical)
//                    .foregroundColor(.white)
//                    .font(.system(size: 36, weight: .semibold, design: .rounded))
//                    .frame(height: self.cart.isConfirmation ? 40 : 0)
//                    .opacity(self.cart.isConfirmation ? 1.00 : 0.00)
//
//                Spacer().frame(height: self.cart.isConfirmation ? 40 : 2)
//
//                //MARK: - Receipt Stack
//                VStack(spacing: 0) {
//                    HStack(spacing: 0) {
//                        Text("Item:")
//                            .padding(.horizontal)
//                            .foregroundColor(Color.white.opacity(0.8))
//                            .font(.system(size: 18, weight: .semibold, design: .rounded))
//                            .frame(maxWidth: .infinity, alignment: .leading)
//
//                        Text("Qty:")
//                            .foregroundColor(Color.white.opacity(0.8))
//                            .font(.system(size: 18, weight: .semibold, design: .rounded))
//                            .frame(maxWidth: .infinity)
//
//                        Text("Price:")
//                            .padding(.horizontal)
//                            .foregroundColor(Color.white.opacity(0.8))
//                            .font(.system(size: 18, weight: .semibold, design: .rounded))
//                            .frame(maxWidth: .infinity, alignment: .trailing)
//                    } //: HStack - Column Titles
//
//                    Divider().background(Color.white).padding(.horizontal)
//
//                    Spacer().frame(height: 10)
//
//                    //MARK: - Cart Items List
//                    List {
//                        ForEach(self.cart.cartItems, id: \.id) { cartItem in
//                            CartItemView(cart: self.cart, cartItem: cartItem)
//                        }
//                        .onDelete(perform: { indexSet in
//                            self.cart.removeItem(atOffsets: indexSet)
//                        })
//                        .listRowBackground(Color.clear)
//                        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
//                    } //: List - Cart Items
//                    .padding(0)
//
//                    Divider().background(Color.white).padding(.horizontal)
//
//
//                    //MARK: - Cart Total Stack
//                    HStack {
//                        Text("Total: ")
//                            .foregroundColor(.white)
//                            .font(.system(size: 24, weight: .semibold, design: .rounded))
//                            .frame(maxWidth: .infinity, alignment: .leading)
//
//                        Text(self.cart.cartTotalString)
//                            .foregroundColor(.white)
//                            .font(.system(size: 24, weight: .semibold, design: .rounded))
//                            .frame(width: 150, alignment: .trailing)
//                    } //: HStack - Cart Total
//                    .frame(height: self.cart.isConfirmation ? 50 : 30)
//                    .padding()
//                    .opacity(self.cart.isConfirmation ? 0 : 1)
//
//
//                } //: VStack - Receipt Stack
//                .frame(maxWidth: self.cart.isConfirmation ? K.Sizes.cartWidth : 600)
//
//                //MARK: - Checkout Button
//                Button(action: {
//                    if !self.cart.isConfirmation {
//                        withAnimation {
//                            self.cart.isConfirmation = true
//                        }
//                    } else {
//                        self.cart.finishSale()
//                    }
//                }) {
//                    Text(self.cart.isConfirmation ? "Confirm Sale" : "Checkout")
//                        .foregroundColor(.white)
//                        .font(.system(size: 24, weight: .semibold, design: .rounded))
//                } //: Button - Checkout
//                .frame(maxWidth: 500, minHeight: 60)
//                .background(K.Backgrounds.greenButton)
//                .cornerRadius(30, corners: self.cart.isConfirmation ? [.allCorners] : [.bottomLeft])
//
//                Spacer().frame(height: self.cart.isConfirmation ? 70 : 0)
//
//            } //: VStack - Cart Stack
//            .frame(width: self.cart.isConfirmation ? UIScreen.main.bounds.width : K.Sizes.cartWidth)
//            .background(
//                K.Backgrounds.cartView
//                    .cornerRadius(self.cart.isConfirmation ? 0 : 30, corners: [.topLeft, .bottomLeft])
//                    .edgesIgnoringSafeArea(.all)
//                    .shadow(color: .black, radius: 10, x: 0, y: 0)
//            )
//        } //: HStack
//        .animation(.spring())
    } //: Body
}
}

