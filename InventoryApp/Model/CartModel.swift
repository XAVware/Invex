//
//  CartModel.swift
//  InventoryApp
//
//  Created by Ryan Smetana on 12/10/20.
//

import SwiftUI
import RealmSwift

class Cart: ObservableObject {
    @Published var cartItems: [SaleItem] = []
    @Published var cartTotalString: String = "$ 0.00"
    
    @Published var isEditable: Bool = true
    
    func addItem(_ item: Item) {
                
        for cartItem in cartItems {
            if cartItem.name == item.name {
                cartItem.increaseQtyInCart()
                self.updateTotal()
                return
            }
        }
        
        let tempCartItem = SaleItem()
        tempCartItem.name = item.name
        
        guard let priceDouble = Double(item.retailPrice) else {
            print("Error casting retail price as double -- Returning")
            return
        }
        
        tempCartItem.price = priceDouble
        
        self.cartItems.append(tempCartItem)
        
        self.updateTotal()
    }
    
    func removeItem(atOffsets offsets: IndexSet) {
        self.cartItems.remove(atOffsets: offsets)
        updateTotal()
    }
    
    func updateTotal() {
        var tempTotal: Double = 0
        for cartItem in cartItems {
            tempTotal += cartItem.subtotal
        }
        
        self.cartTotalString = "$ \(String(format: "%.2f", tempTotal))"
    }
}
