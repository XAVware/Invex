//
//  InventoryItem.swift
//  InventoryX
//
//  Created by Smetana, Ryan on 5/23/23.
//

import SwiftUI
import RealmSwift

class ItemEntity: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted(originProperty: "items") var department: LinkingObjects<DepartmentEntity>
    
    @Persisted var name: String
    @Persisted var attribute: String
    @Persisted var retailPrice: Double
    @Persisted var avgCostPer: Double
    @Persisted var onHandQty: Int
    
    convenience init(name: String, attribute: String = "", retailPrice: Double, avgCostPer: Double, onHandQty: Int = 0) {
        self.init()
        self.name = name
        self.retailPrice = retailPrice
        self.avgCostPer = avgCostPer
        self.onHandQty = onHandQty
    }
}

extension ItemEntity {
    static let item1 = ItemEntity(name: "Lays", retailPrice: 1.00, avgCostPer: 0.50, onHandQty: 10)
    static let item2 = ItemEntity(name: "Skittles", retailPrice: 1.50, avgCostPer: 0.50, onHandQty: 15)
    static let item3 = ItemEntity(name: "Starburst", retailPrice: 1.00, avgCostPer: 0.50, onHandQty: 10)
    static let item4 = ItemEntity(name: "Water", retailPrice: 1.00, avgCostPer: 0.50, onHandQty: 4)
    static let item5 = ItemEntity(name: "Gatorade", retailPrice: 1.00, avgCostPer: 0.50, onHandQty: 10)
    static let item6 = ItemEntity(name: "Energy Drink", retailPrice: 3.00, avgCostPer: 0.50, onHandQty: 7)
    static let item7 = ItemEntity(name: "Ice Pop", retailPrice: 0.50, avgCostPer: 0.50, onHandQty: 13)

    static let foodArray = [item1, item2, item3]
    static let drinkArray = [item4, item5, item6]
    static let frozenArray = [item7]
}

//class InventoryItemModel {
//    let id: ObjectId
//    let name: String?
//    var retailPrice: Double?
//    var avgCostPer: Double?
//    var onHandQty: Int?
//    
//    var qtyInCart: Int?
//    
//    var cartItemSubtotal: Double {
//        guard let price = retailPrice, let qty = qtyInCart else { return -1.0 }
//        return price * Double(qty)
//    }
//    
//    
//    init(id: ObjectId, name: String?, retailPrice: Double? = nil, avgCostPer: Double? = nil, onHandQty: Int? = nil, qtyInCart: Int? = nil) {
//        self.id = id
//        self.name = name
//        self.retailPrice = retailPrice
//        self.avgCostPer = avgCostPer
//        self.onHandQty = onHandQty
//        self.qtyInCart = qtyInCart
//    }
//}
