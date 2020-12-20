//
//  ItemModel.swift
//  InventoryApp
//
//  Created by Ryan Smetana on 12/9/20.
//

import SwiftUI
import RealmSwift

class Item: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var type: String = ""
    @objc dynamic var retailPrice: String = "0.00"
    @objc dynamic var avgCostPer: Double = 0.00
    @objc dynamic var onHandQty: Int = 0
}


class CartItem: ObservableObject {
    var id = UUID()
    @Published var name: String = ""
    @Published var type: String = ""
    @Published var qtyToPurchase: Int = 1
    @Published var retailPrice: String = ""
}
