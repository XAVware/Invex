//
//  TypeData.swift
//  ConcessionTracker
//
//  Created by Ryan Smetana on 1/20/21.
//

import SwiftUI
import RealmSwift

//var concessionTypes: [Type] = [
//    Type(type: "Food / Snack", restockNumber: 10),
//    Type(type: "Beverage", restockNumber: 15),
//    Type(type: "Frozen", restockNumber: 10)
//]

let categoryList: [Category] = {
    var tempList: [Category] = []
    
    let results = try! Realm().objects(Category.self)
    
    for category in results {
        tempList.append(category)
    }
    
    return tempList
}()
