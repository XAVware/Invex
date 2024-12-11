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
    @Persisted var finishedOnboarding: Bool = false
//    @Persisted var industry: String // Could be used for improving the app based on popular demand
//    @Persisted var email: String
//    @Persisted var streetAddress: String?
//    @Persisted var city: String?
//    @Persisted var state: String?
//    @Persisted var zipCode: String?
    
    convenience init(name: String, taxRate: Double = 0) {
        self.init()
        self.name = name
        self.taxRate = taxRate
    }
    
//    var formattedTaxRate: String {
//        return taxRate.toPercentageString()
//        
//    }
}
