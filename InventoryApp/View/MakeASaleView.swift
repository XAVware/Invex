//
//  MakeASaleView.swift
//  InventoryApp
//
//  Created by Ryan Smetana on 12/11/20.
//

import SwiftUI

struct MakeASaleView: View {
    @ObservedObject var appManager: AppStateManager
    @ObservedObject var cart: Cart
    
    @State var typeID: Int = 0
    var types = ["Food / Snack", "Beverage", "Frozen"]
    let layout = [
        GridItem(.adaptive(minimum: 180))
    ]
    
    var body: some View {
        HStack(spacing: 0) {
            
            
            //MARK: - Make A Sale Item Button Dashboard
            VStack(alignment: .center, spacing: 10) {
                
                Picker(selection: $typeID, label: Text("")) {
                    ForEach(0 ..< types.count) { index in
                        Text(self.types[index]).foregroundColor(.black).tag(index)
                        
                    }
                }
                .padding()
                .pickerStyle(SegmentedPickerStyle())
                .frame(width: 400, height: 15)
                
                ScrollView {
                    LazyVGrid(columns: layout, spacing: 20) {
                        ForEach(self.appManager.itemList, id: \.self) { item in
                            if item.type == self.types[self.typeID] {
                                ItemButton(cart: self.cart, item: item)
                            }
                        }
                    }
                    .padding()
                }
                
                
            }
            .background(Color.white)
            .padding()
            .frame(width: (UIScreen.main.bounds.width / 3) * 2)
            
            //MARK: - Cart Section
            ZStack {
                K.BackgroundGradients.cartView
                
                VStack(spacing: 0) {
                    Text("Cart")
                        .padding(.vertical, 7)
                        .foregroundColor(.white)
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                    
                    HStack(spacing: 0) {
                        Text("Item:")
                            .padding(.horizontal)
                            .foregroundColor(Color.white.opacity(0.8))
                            .font(.system(size: 18, weight: .semibold, design: .rounded))
                            .frame(width: 120, alignment: .leading)
                        
                        Text("Qty:")
                            .foregroundColor(Color.white.opacity(0.8))
                            .font(.system(size: 18, weight: .semibold, design: .rounded))
                            .frame(width: 120)
                        
                        Text("Price:")
                            .padding(.horizontal)
                            .foregroundColor(Color.white.opacity(0.8))
                            .font(.system(size: 18, weight: .semibold, design: .rounded))
                            .frame(width: 120, alignment: .trailing)
                    }
                    
                    Divider().background(Color.white).padding(.horizontal)
                    
                    Spacer().frame(height: 10)
                    
                    List {
                        ForEach(self.cart.cartItems, id: \.id) { cartItem in
                            CartItemView(cart: self.cart, cartItem: cartItem)
                        }
                        .onDelete(perform: { indexSet in
                            self.cart.removeItem(atOffsets: indexSet)
                        })
                        .listRowBackground(Color.clear)
                        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    }
                    .padding(0)
                    
                    Divider().background(Color.white).padding(.horizontal)
                    
                    HStack {
                        Text("Total: ")
                            .foregroundColor(.white)
                            .font(.system(size: 24, weight: .semibold, design: .rounded))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text(self.cart.cartTotalString)
                            .foregroundColor(.white)
                            .font(.system(size: 24, weight: .semibold, design: .rounded))
                            .frame(width: 150, alignment: .trailing)
                    }
                    .padding()
                    
                    Button(action: {
                        for item in self.cart.cartItems {
                            print(item.qtyToPurchase)
                        }
                    }) {
                        Text("Checkout")
                            .foregroundColor(.black)
                            .font(.system(size: 24, weight: .semibold, design: .rounded))
                    }
                    .frame(maxWidth: .infinity, minHeight: 60)
                    .background(K.BackgroundGradients.checkoutButton)
                }
            } //: ZStack - Cart Section
            .frame(width: UIScreen.main.bounds.width / 3)
            
        } //: HStack
        .background(Color.white)
    } //: VStack used to keep header above all pages
    
}

//struct MakeASaleView_Previews: PreviewProvider {
//    static var previews: some View {
//        MakeASaleView()
//    }
//}
