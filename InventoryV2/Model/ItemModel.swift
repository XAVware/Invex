//
//  ItemModel.swift
//  InventoryApp
//
//  Created by Ryan Smetana on 12/9/20.
//

import SwiftUI
import RealmSwift

class Item: Object {
    @objc dynamic var name: String          = ""
    @objc dynamic var subtype: String       = ""
    @objc dynamic var type: String          = ""
    @objc dynamic var retailPrice: String   = "0.00"
    @objc dynamic var avgCostPer: Double    = 0.00
    @objc dynamic var onHandQty: Int        = 0
}

class SaleItem: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var qtyToPurchase: Int = 0
    @objc dynamic var price: Double = 0.00
}


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
