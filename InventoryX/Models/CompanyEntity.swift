//
//  CompanyEntity.swift
//  InventoryX
//
//  Created by Ryan Smetana on 3/24/24.
//

import SwiftUI
import RealmSwift

class CompanyEntity: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var name: String
    @Persisted var taxRate: Double
    
    convenience init(name: String, taxRate: Double = 0) {
        self.init()
        self.name = name
        self.taxRate = taxRate
    }
    
    var formattedTaxRate: String {
        return taxRate.toPercentageString()
        
    }
    
    
}
