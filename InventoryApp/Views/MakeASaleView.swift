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
                    LazyVGrid(columns: layout, spacing: 10) {
                        ForEach(self.appManager.itemList, id: \.self) { item in
                            if item.type == self.types[self.typeID] {
                                ItemButton(cart: self.cart, item: item)
                            }
                        }
                    }
                } //: ScrollView
                
            } //: VStack
            .padding()
            .frame(width: UIScreen.main.bounds.width - K.Sizes.cartWidth)
            
            Spacer().frame(width: K.Sizes.cartWidth)
            
        } //: HStack
        .background(Color.white)
        .onTapGesture {
            self.appManager.getAllSales()
        }
        
    } //: VStack used to keep header above all pages
    
}
