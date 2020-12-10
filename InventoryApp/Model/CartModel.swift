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
        var itemIndex: Int = 0
        let itemName = item.name
        let type = item.type
        var quantityToPurchase = 1
        let price = item.retailPrice
        
        
        for cartItem in cartItems {
            if cartItem.name == item.name {
                quantityToPurchase = cartItem.qtyToPurchase + 1
                cartItems.remove(at: itemIndex)
                break
            } else {
                itemIndex += 1
                
            }
        }
        
        let tempCartItem = CartItem(name: itemName, type: type, qtyToPurchase: quantityToPurchase, retailPrice: price)
        
        if cartItems.isEmpty {
            cartItems.append(tempCartItem)
        } else {
            cartItems[itemIndex] = tempCartItem            
        }
        
        var tempTotal: Double = 0
        for cartItem in cartItems {
            tempTotal += (Double(cartItem.retailPrice)! * Double(cartItem.qtyToPurchase))
        }
        
        let tempTotalString: String = String(format: "%.2f", tempTotal)
        cartTotalString = "$ \(tempTotalString)"
        
    }
}
