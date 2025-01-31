//
//  Department.swift
//  InventoryX
//
//  Created by Ryan Smetana on 5/22/23.
//

import SwiftUI
import RealmSwift

class DepartmentEntity: Object, ObjectKeyIdentifiable, Identifiable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var name: String
    @Persisted var restockNumber: Int
    @Persisted var items: RealmSwift.List<ItemEntity>
    @Persisted var defMarkup: Double
    
    convenience init(name: String, restockNum: Int = 10, defMarkup: Double = 0.0) {
        self.init()
        self.name = name
        self.restockNumber = restockNum
        self.defMarkup = defMarkup
    }
}

