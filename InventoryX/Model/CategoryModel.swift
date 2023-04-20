//
//  CategoryModel.swift
//  ConcessionTracker
//
//  Created by Smetana, Ryan on 6/17/21.
//

import SwiftUI
import RealmSwift

class Category: Object {
    @objc dynamic var name: String          = ""
    @objc dynamic var restockNumber         = 0
}
