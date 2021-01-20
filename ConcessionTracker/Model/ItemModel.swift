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
    @objc dynamic var itemType: String      = ""
    @objc dynamic var retailPrice: Double   = 0.00
    @objc dynamic var avgCostPer: Double    = 0.00
    @objc dynamic var onHandQty: Int        = 0
}
