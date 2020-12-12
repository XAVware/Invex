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
            .padding()
            .frame(width: (UIScreen.main.bounds.width / 3) * 2)
            
            //MARK: - Cart Section
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color(hex: "141E30").opacity(0.8), Color(hex: "243B55").opacity(0.7)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                
                
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
                    
                    Divider()
                        .background(Color.white)
                        .padding(.horizontal)
                    
                    Spacer().frame(height: 10)
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        ForEach(self.cart.cartItems, id: \.id) { cartItem in
                            CartItemView(cart: self.cart, cartItem: cartItem)
                        }
                        .onDelete(perform: { indexSet in
                            print("Delete IndexSet: \(indexSet)")
                        })
                    }
                    
                    Divider()
                        .background(Color.white)
                        .padding(.horizontal)
                    
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
                    .background(Color.green)
                }
            } //: ZStack - Cart Section
            .frame(width: UIScreen.main.bounds.width / 3)
            
        } //: VStack
        
    } //: VStack used to keep header above all pages
    
    init(appManager: AppStateManager, cart: Cart) {
        self.appManager = appManager
        self.cart = cart
        UITableView.appearance().backgroundColor = UIColor.clear
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(named: "ColorWatermelonDark")
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.black], for: .normal)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
    }
}

//struct MakeASaleView_Previews: PreviewProvider {
//    static var previews: some View {
//        MakeASaleView()
//    }
//}
