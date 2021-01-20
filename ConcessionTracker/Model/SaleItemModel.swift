//
//  SaleItemModel.swift
//  ConcessionTracker
//
//  Created by Ryan Smetana on 1/20/21.
//

import SwiftUI
import RealmSwift

class SaleItem: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var qtyToPurchase: Int = 0
    @objc dynamic var price: Double = 0.00
}
