//
//  PointOfSaleViewModel.swift
//  InventoryX
//
//  Created by Ryan Smetana on 5/11/24.
//

import Foundation
import RealmSwift

@MainActor class PointOfSaleViewModel: ObservableObject {
    @Published var cartItems: Array<ItemEntity> = .init()
    @Published var companyName: String = ""
    @Published var taxRate: Double = 0.0
    
    /// Computed array of unique items in the cart. `CartView` uses this to display a
    /// section for each item, without re-ordering them. The array of `@Published cartItems`
    /// in `PointOfSaleViewModel` can then be queried by the view to find data on each
    /// unique item such as the quantity in cart and its subtotal. This allows for re-use
    /// of `ItemEntity`. `.uniqued()` requires `Swift Algorithms.`
    var uniqueItems: [ItemEntity] { Array(cartItems.uniqued()) }
    
    var cartSubtotal: Double { cartItems.reduce(0) { $0 + $1.retailPrice } }
    var taxAmount: Double { cartSubtotal * taxRate / 100 }
    var total: Double { cartSubtotal + taxAmount }
    
    var cartItemCount: Int { cartItems.count }
    
    
    
    func addItemToCart(_ item: ItemEntity) {
        cartItems.append(item)
    }
    
    func removeItemFromCart(_ item: ItemEntity) {
        if let itemIndex = cartItems.firstIndex(of: item) {
            cartItems.remove(at: itemIndex)
        } else {
            print("No item found")
        }
    }
    
    func fetchCompany() {
        do {
            guard let company = try RealmActor().fetchCompany() else {
                print("Error fetching company")
                return
            }
            self.companyName = company.name
            self.taxRate = company.taxRate
        } catch {
            debugPrint(error.localizedDescription)
        }
        
    }
    
    // TODO: Maybe, Only call this when initialized. Then increment stored property.
    func calcNextSaleNumber() -> Int {
        var count: Int = 0
        do {
            count = try RealmActor().getSalesCount()
//            let realm = try Realm()
//            let salesCount = realm.objects(SaleEntity.self).count
//            count = salesCount + 1
        } catch {
            debugPrint(error.localizedDescription)
        }
        return count + 1
    }
    
    func finalizeSale(completion: @escaping (() -> Void)) async {
        // TODO: 1 & 2 might be able to run at the same time.
        // 1. Update the on-hand quantity for each unique item in the cart
        for index in 0...uniqueItems.count - 1 {
            let tempItem = uniqueItems[index]
            let cartQty = cartItems.filter { $0._id == tempItem._id }.count
            do {
                try await RealmActor().adjustStock(for: tempItem, by: cartQty)
                
            } catch {
                debugPrint("Error saving item in sale: \(tempItem)")
            }
        }
                
        /// Convert ItemEntities to SaleItemEntities so they can be used in the sale, without
        /// risking losing an item record on delete.
        let saleItems = cartItems.map( { SaleItemEntity(item: $0) } )
        
        do {
            try await RealmActor().saveSale(items: saleItems, total: self.total)
            cartItems.removeAll()
            completion()
        } catch {
            debugPrint(error.localizedDescription)
        }
        
    }
}
