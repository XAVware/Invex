//
//  Models.swift
//  InventoryX
//
//  Created by Smetana, Ryan on 4/24/23.
//

import SwiftUI
import RealmSwift
import Realm



enum UserRole: String, PersistableEnum {
    case admin
    case manager
    case employee
}

class UserEntity: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var profileName: String = ""
    @Persisted var email: String?
    @Persisted var passcode: String?
    @Persisted var role: UserRole = UserRole.employee
    
    convenience init(profileName: String, email: String?, passcode: String?, role: UserRole) {
        self.init()
        self.profileName = profileName
        self.email = email
        self.role = role
    }
}

