//
//  CartItem.swift
//  InventoryX
//
//  Created by Smetana, Ryan on 5/22/23.
//

import SwiftUI

class CartItem: ObservableObject {
    var id = UUID()
    @Published var name: String         = ""
    @Published var qtyToPurchase: Int   = 1
    @Published var subtype: String      = ""
    @Published var price: Double        = 0.00
    
    var subtotal: Double {
        return Double(self.qtyToPurchase) * self.price
    }
    
    var subtotalString: String {
        let tempSubtotalString: String = String(format: "%.2f", subtotal)
        return "$ \(tempSubtotalString)"
    }
    
    func increaseQtyInCart() {
        if self.qtyToPurchase < 24 {
            self.qtyToPurchase += 1
        }
    }
    
    func decreaseQtyInCart() {
        if self.qtyToPurchase != 0 {
            self.qtyToPurchase -= 1
        }
    }
    
}
