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
    
    @State var colorHexString: String = ""
    
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
            self.cart.addItemToCart(item: self.item)
            print(cart.cartItems)
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
        .background(
            backgroundColor
                .cornerRadius(15)
                .shadow(radius: 4)
        )
        .padding()

        
    }
    
    init(cart: Cart, item: Item) {
        self.cart = cart
        self.item = item
        if item.type == "Beverage" {
            self.colorHexString = "f7797d"
        } else {
            self.colorHexString = "193658"
        }
    }
    
}

//struct BeverageButton_Previews: PreviewProvider {
//    static var previews: some View {
//        BeverageButton()
//            .previewLayout(.sizeThatFits)
//    }
//}
