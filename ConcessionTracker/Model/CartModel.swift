

import SwiftUI
import RealmSwift

class Cart: ObservableObject {
    @Published var cartItems: [CartItem]        = []
    @Published var cartTotalString: String      = "$ 0.00"
    @Published var isEditable: Bool             = true
    @Published var isConfirmation: Bool         = false
    
    func finishSale() {
        guard !cartItems.isEmpty else {
            print("There are no items in the cart -- Returning")
            return
        }
        
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
        
        
        //Save Sale
        let config = Realm.Configuration(schemaVersion: 1)
        do {
            let realm = try Realm(configuration: config)
            try realm.write ({
                realm.add(sale)
            })
        } catch {
            print("Error saving sale: -- Returning")
            print(error.localizedDescription)
            return
        }
        
        //Adjust Quantities
        for cartItem in cartItems {
            let predicate = NSPredicate(format: "name == %@", cartItem.name)
            do {
                let realm = try Realm(configuration: config)
                let result = realm.objects(Item.self).filter(predicate)
                for item in result {
                    if item.subtype == cartItem.subtype {
                        try realm.write ({
                            item.onHandQty -= cartItem.qtyToPurchase
                            realm.add(item)
                        })
                    }
                }
            } catch {
                print(error.localizedDescription)
                return
            }
        }
        
        self.resetCart()
    }
    
    func resetCart() {
        self.cartItems = []
        self.cartTotalString = "$ 0.00"
        withAnimation {
            self.isEditable = true
            self.isConfirmation = false
        }
    }
    
    func addItem(_ item: Item) {
        for cartItem in cartItems {
            if cartItem.name == item.name && cartItem.subtype == item.subtype {
                cartItem.increaseQtyInCart()
                self.updateTotal()
                return
            }
        }
        
        let tempCartItem = CartItem()
        tempCartItem.name = item.name
        tempCartItem.subtype = item.subtype
        tempCartItem.price = item.retailPrice
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
