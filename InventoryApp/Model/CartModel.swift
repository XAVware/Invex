//
//  CartModel.swift
//  InventoryApp
//
//  Created by Ryan Smetana on 12/10/20.
//

import SwiftUI
import RealmSwift

class Cart: ObservableObject {
    @Published var cartItems: [CartItem] = []
    @Published var cartTotalString: String = "$ 0.00"

    
    func addItemToCart(item: Item) {
        var itemIsInCart: Bool = false
                
        let tempCartItem = CartItem()
        tempCartItem.name = item.name
        tempCartItem.type = item.type
        tempCartItem.retailPrice = item.retailPrice
        
        for cartItem in cartItems {
            if cartItem.name == item.name {
                itemIsInCart = true
                increaseQuantity(forItem: cartItem)
                break
            }
        }
        
        if !itemIsInCart { cartItems.append(tempCartItem) }

        updateTotal()
    }
    
    func removeItem(atOffsets offsets: IndexSet) {
        self.cartItems.remove(atOffsets: offsets)
        updateTotal()
    }
    
    func increaseQuantity(forItem cartItem: CartItem) {
        cartItem.qtyToPurchase += 1
        updateTotal()
    }
    
    func decreaseQuantity(forItem cartItem: CartItem) {
        cartItem.qtyToPurchase -= 1
        updateTotal()
    }
    
    func updateTotal() {
        var tempTotal: Double = 0
        for cartItem in cartItems {
            tempTotal += (Double(cartItem.retailPrice)! * Double(cartItem.qtyToPurchase))
        }
        
        let tempTotalString: String = String(format: "%.2f", tempTotal)
        cartTotalString = "$ \(tempTotalString)"
    }
}
