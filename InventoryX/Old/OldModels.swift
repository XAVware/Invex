//
//  OldModels.swift
//  InventoryX
//
//  Created by Smetana, Ryan on 4/27/23.
//

import SwiftUI
import RealmSwift

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
                let result = realm.objects(InventoryItem.self).filter(predicate)
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
    
    func addItem(_ item: InventoryItem) {
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

class Category: Object {
    @objc dynamic var name: String          = ""
    @objc dynamic var restockNumber         = 0
}


class InventoryItem: Object {
    @objc dynamic var name: String          = ""
    @objc dynamic var subtype: String       = ""
    @objc dynamic var itemType: String      = ""
    @objc dynamic var retailPrice: Double   = 0.00
    @objc dynamic var avgCostPer: Double    = 0.00
    @objc dynamic var onHandQty: Int        = 0
}


class SaleDateManager {
    var calendar: Calendar {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        calendar.firstWeekday = 1
        return calendar
    }
        
    var today: Date {
        return Date()
    }
    
    var startOfToday: Date {
        return self.calendar.startOfDay(for: self.today)
    }
    
    var endOfToday: Date {
        return self.calendar.date(bySettingHour: 23, minute: 59, second: 59, of: self.today)!
    }
    
    var yesterday: Date {
        return self.calendar.date(byAdding: .day, value: -1 , to: self.today)!
    }
    
    var startOfYesterday: Date {
        return self.calendar.startOfDay(for: self.yesterday)
    }
    
    var endOfYesterday: Date {
        return self.calendar.date(bySettingHour: 23, minute: 59, second: 59, of: self.yesterday)!
    }
    
    var thisWeek: [Date] {
        var week: [Date] = []
        if let weekInterval = self.calendar.dateInterval(of: .weekOfYear, for: self.today) {
            for i in 0...6 {
                if let day = self.calendar.date(byAdding: .day, value: i, to: weekInterval.start) {
                    week.append(day)
                }
            }
        }
        return week
    }
    
    var startOfThisWeek: Date {
        return self.thisWeek[0]
    }
    
    var endOfThisWeek: Date {
        let lastDay = self.thisWeek[self.thisWeek.count - 1]
        return self.calendar.date(bySettingHour: 23, minute: 59, second: 59, of: lastDay)!
    }
    
    var lastWeek: [Date] {
        let oneWeekAgo: Date = calendar.date(byAdding: .weekOfYear, value: -1, to: self.today)!
        var week: [Date] = []
        if let weekInterval = self.calendar.dateInterval(of: .weekOfYear, for: oneWeekAgo) {
            for i in 0...6 {
                if let day = self.calendar.date(byAdding: .day, value: i, to: weekInterval.start) {
                    week.append(day)
                }
            }
        }
        return week
    }
    
    var startOfLastWeek: Date {
        return self.lastWeek[0]
    }
    
    var endOfLastWeek: Date {
        let lastDay = self.lastWeek[self.lastWeek.count - 1]
        return self.calendar.date(bySettingHour: 23, minute: 59, second: 59, of: lastDay)!
    }
}


class SaleItem: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var subtype: String = ""
    @objc dynamic var qtyToPurchase: Int = 0
    @objc dynamic var price: Double = 0.00
}


class Sale: Object {
    @objc dynamic var timestamp: Date = Date()
    var items = RealmSwift.List<SaleItem>()
    @objc dynamic var total: Double = 0.00

}


struct Type: Identifiable {
    var id = UUID()
    var type: String
    var restockNumber: Int
}
