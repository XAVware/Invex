//
//  BeverageButton.swift
//  InventoryApp
//
//  Created by Ryan Smetana on 12/9/20.
//

import SwiftUI

struct ItemButton: View {
    @ObservedObject var cart: Cart
    var item: InventoryItem
    
    var backgroundColor: Color {
        switch item.itemType {
        case categoryList[0].name:
            return Color("SnackColor")
        case categoryList[1].name:
            return Color("BeverageColor")
        case categoryList[2].name:
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

                if (self.item.subtype != "") {
                    Text(self.item.subtype)
                        .font(.system(size: 14, weight: .light, design:.rounded))
                }
            }
            .foregroundColor(.black)
            .frame(width: 140, height: 80)
            .background(self.backgroundColor)
        }
        .cornerRadius(9)
        .padding()
    }
}
