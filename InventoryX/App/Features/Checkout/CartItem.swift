//
//  CartItem.swift
//  InventoryX
//
//  Created by Ryan Smetana on 12/26/24.
//

import Foundation
import RealmSwift

struct CartItem: Identifiable, Hashable {
    var id: ObjectId
    var name: String
    var attribute: String
    var retailPrice: Double
    var qtyInCart: Int
    
    init(from itemEntity: ItemEntity) {
        self.id = itemEntity._id
        self.name = itemEntity.name
        self.attribute = itemEntity.attribute
        self.retailPrice = itemEntity.retailPrice
        self.qtyInCart = 1
    }
    
    func convertToSaleItem() -> SaleItemEntity {
        return SaleItemEntity(item: self)
    }
    
}
