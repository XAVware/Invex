//
//  BeverageButton.swift
//  InventoryApp
//
//  Created by Ryan Smetana on 12/9/20.
//

import SwiftUI

struct ItemButton: View {
    @ObservedObject var cart: Cart
    var item: Item
    
    var backgroundColor: Color {
        switch item.itemType {
        case "Food / Snack":
            return Color("SnackColor")
        case "Beverage":
            return Color("BeverageColor")
        case "Frozen":
            return Color("FrozenColor")
        default:
            return Color.white
        }
    }
    
    var body: some View {
        Button(action: {
            self.cart.addItem(self.item)
        }) {
            VStack(spacing: 0) {
                Text(self.item.name)
                    .font(.system(size: 18, weight: .semibold, design:.rounded))
                
                Text(self.item.subtype)
                    .font(.system(size: 12, weight: .light, design:.rounded))
            }
            .foregroundColor(.black)
            .frame(width: 140, height: 60)
            .background(self.backgroundColor)
        }
        .cornerRadius(9)
        .padding()
    }
}
