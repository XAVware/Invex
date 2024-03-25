//
//  MakeASaleViewModel.swift
//  InventoryX
//
//  Created by Ryan Smetana on 3/18/24.
//

import SwiftUI
import RealmSwift

class MakeASaleViewModel: ObservableObject {
//    @Published var cartItems: [InventoryItemModel] = []
        @Published var cartItems: [InventoryItemModel] = [InventoryItemModel(id: ItemEntity.item1._id, name: ItemEntity.item1.name, retailPrice: ItemEntity.item1.retailPrice, qtyInCart: 2),
                                                          InventoryItemModel(id: ItemEntity.item4._id, name: ItemEntity.item4.name, retailPrice: ItemEntity.item4.retailPrice, qtyInCart: 1),
                                                          InventoryItemModel(id: ItemEntity.item5._id, name: ItemEntity.item5.name, retailPrice: ItemEntity.item5.retailPrice, qtyInCart: 6)]
//    @Published var isConfirmingSale: Bool = false
    //    @Published var isShowingCartPreview: Bool = true
    
    func itemTapped(item: ItemEntity) {
        if let _ = cartItems.first(where: { $0.id == item._id }) {
            // Item is already in cart, adjust quantity
            adjustQuantityInCart(item: item, by: 1)
        } else {
            //Item is not already in cart, append
            addItem(item)
        }
    }
    
//    func checkoutTapped() {
//        //Remove items from cart if the quantity is 0 and check that there are still items in cart.
//        cartItems.removeAll (where: { $0.qtyInCart == 0 })
//        guard !cartItems.isEmpty else { return }
//        
//        isConfirmingSale = true
//    }
    
//    func finalizeTapped() {
//        finalizeSale()
//    }
    
//    func cancelTapped() {
//        returnToMakeASale()
//    }
    
    private func addItem(_ item: ItemEntity) {
        let tempCartItem = InventoryItemModel(id: item._id, name: item.name, retailPrice: item.retailPrice, qtyInCart: 1)
        cartItems.append(tempCartItem)
    }
    
    private func adjustQuantityInCart(item: ItemEntity, by amount: Int) {
        guard let existingItem = cartItems.first(where: { $0.id == item._id }) else { return }
        guard let index = cartItems.firstIndex(where: { $0.id == item._id }) else { return }
        let newQty = (existingItem.qtyInCart ?? -2) + 1
        //FOR TESTING
        let tempCartItem = InventoryItemModel(id: item._id, name: item.name, retailPrice: item.retailPrice, qtyInCart: newQty)
        cartItems[index] = tempCartItem
    }
    
    /// When a sale is finalized, the on-hand quantity of each item sold needs to be updated to reflect the items that were sold and a Sale needs to be created and saved.
    ///     - When Checkout is first tapped, all items that have a nil or 0 qtyInCart are removed from cartItems array. This line should not be necessary. Maybe use closure to pass $0 to funtion.
    func finalizeSale(completion: @escaping (() -> Void)) {
        cartItems.forEach { item in
        guard let qtySold = item.qtyInCart else { return }
            Task {
                do {
                    let realm = try await Realm()
                    
                    guard let result = realm.object(ofType: ItemEntity.self, forPrimaryKey: item.id) else {
                        LogService(self).error("No item found with id: \(item.id)")
                        return
                    }
                    
                    let newOnHandQty = result.onHandQty - qtySold
                    
//                    let realm = try await Realm()
                    try await realm.asyncWrite {
                        item.onHandQty = newOnHandQty
                    }
//                    try await DataService.updateItemOnHandQty(result, newQty: newOnHandQty)
                    LogService(self).info("Finished saving sale. New Qty should be \(result.onHandQty - qtySold)")
                } catch {
                    LogService(self).error(error.localizedDescription)
                }
            }
        }
        
        //Create and save sale in Realm
        let saleTotal = cartItems
            .map({ Double($0.retailPrice! * Double($0.qtyInCart!)) })
            .reduce(into: 0.0, { $0 += $1 })
        
        let newSale = SaleEntity(timestamp: Date(), total: saleTotal)
        
        cartItems.forEach { item in
            guard let name = item.name, let qtySold = item.qtyInCart, let price = item.retailPrice else { return }
            let saleItem = SaleItemEntity(name: name, qtyToPurchase: qtySold, unitPrice: price)
            newSale.items.append(saleItem)
        }
        
        Task {
            do {
                
                let realm = try await Realm()
                try await realm.asyncWrite { realm.add(newSale) }
                
//                try await DataService.saveSale(newSale)
                print("Sale saved")
                cartItems.removeAll()
                completion()
            } catch {
                LogService(self).error("Error saving sale: \(error.localizedDescription)")
            }
        }
        
    }

    
}


