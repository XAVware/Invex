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
        switch item.type {
        case "Food / Snack":
            return Color(hex: "f7797d")
        case "Beverage":
            return Color(hex: "f2c94c")
        case "Frozen":
            return Color(hex: "6dd5ed")
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
                    .font(.system(size: 18, weight: .bold, design:.rounded))
                    .foregroundColor(.black)
                    
                Text("$ \(self.item.retailPrice)")
                    .font(.system(size: 14, weight: .semibold, design:.rounded))
                    .foregroundColor(.black)
                    
            }
            
        }
        .frame(minWidth: 50, maxWidth: 180, minHeight: 40, maxHeight: 40)
        .background(self.backgroundColor)
        .cornerRadius(15)
        .padding()
        .shadow(radius: 4)

        
    }

    
}
