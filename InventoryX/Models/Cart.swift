//
//  Cart.swift
//  InventoryX
//
//  Created by Smetana, Ryan on 5/21/23.
//

import SwiftUI
import RealmSwift

class Cart: ObservableObject {
    //Original
    @Published var cartItems: [CartItem]        = []
    @Published var cartTotalString: String      = "$ 0.00"
    @Published var isEditable: Bool             = true
    @Published var isConfirmation: Bool         = false
    
    //New
    @Published var saleItems: [InventoryItemEntity] = []
    
    func finishSale() {
        guard !cartItems.isEmpty else {
            print("There are no items in the cart -- Returning")
            return
        }
        
        //        saveSale()
        //        saveOnHandQuantities()
        resetCart()
    }
    
    func saveSale() {
        let sale = Sale()
        sale.timestamp = Date()
        var tempTotal: Double = 0.00
        
        for cartItem in cartItems {
            let saleItem = SaleItem()
            saleItem.name = cartItem.name
            saleItem.subtype = cartItem.subtype
            saleItem.price = cartItem.price
            saleItem.qtyToPurchase = cartItem.qtyToPurchase
            tempTotal += (saleItem.price * Double(saleItem.qtyToPurchase))
            sale.items.append(saleItem)
        }
        
        sale.total = tempTotal
        
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(sale)
            }
        } catch {
            print("Error saving sale: -- Returning")
            print(error.localizedDescription)
            return
        }
    }
    
    func saveOnHandQuantities() {
        for cartItem in cartItems {
            let predicate = NSPredicate(format: "name == %@", cartItem.name)
            do {
                let realm = try Realm()
                let result = realm.objects(InventoryItemEntity.self).filter(predicate)
                for item in result {
                    try realm.write {
                        item.onHandQty -= cartItem.qtyToPurchase
                        realm.add(item)
                    }
                    
                }
            } catch {
                print(error.localizedDescription)
                return
            }
        }
    }
    
    func resetCart() {
        cartItems = []
        cartTotalString = "$ 0.00"
        withAnimation {
            isEditable = true
            isConfirmation = false
        }
    }
    
    func addItem(_ item: InventoryItemEntity) {
        //        for cartItem in cartItems {
        //            if cartItem.name == item.name {
        //                cartItem.increaseQtyInCart()
        //                self.updateTotal()
        //                cartItems.forEach { print($0.qtyToPurchase) }
        //                return
        //            }
        //        }
        //
        //        let tempCartItem = CartItem()
        //        tempCartItem.name = item.name
        //        tempCartItem.price = item.retailPrice
        //        cartItems.append(tempCartItem)
        //        updateTotal()
        //        cartItems.forEach { print($0.qtyToPurchase) }
        
        
        //New
        let tempSaleItem = CartItem()
        tempSaleItem.name = item.name
        tempSaleItem.price = item.retailPrice
        saleItems.append(item)
        
        updateTotal()
        
        
    }
    
    func updateTotal() {
        var tempTotal: Double = 0
        for cartItem in cartItems {
            tempTotal += cartItem.subtotal
        }
        cartTotalString = "$ \(String(format: "%.2f", tempTotal))"
        
        print(cartTotalString)
    }
    
    func removeItem(atOffsets offsets: IndexSet) {
        self.cartItems.remove(atOffsets: offsets)
        updateTotal()
    }
    
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
