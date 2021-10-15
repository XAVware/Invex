//
//  Model.swift
//  InventoryTracker_10.2021
//
//  Created by Ryan Smetana on 10/15/21.
//

import Foundation

struct Category: Codable {
    var name: String            = ""
    var restockThresh: Int      = 0
}

struct Item: Codable {
    var name: String            = ""
    var subtype: String         = ""
    var itemType: String        = ""
    var retailPrice: Double     = 0.00
    var avgCostPer: Double      = 0.00
    var onHandQty: Int          = 0
}

struct SaleItem: Codable {
    var name: String            = ""
    var subtype: String         = ""
    var qtyToPurchase: Int      = 0
    var price: Double           = 0.00
}

struct Sale: Codable {
    var timestamp: Date         = Date()
    var items: [SaleItem]       = []
    var total: Double           = 0.00
}

