//
//  UserManager.swift
//  InventoryX
//
//  Created by Smetana, Ryan on 4/27/23.
//

import SwiftUI
import RealmSwift

class UserManager: ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var currentUser: UserEntity?
    
    func loginUser(_ user: UserEntity) {
        print("Logging in User: \(user)")
        currentUser = user
        isLoggedIn = true
    }
    
    func signOut() {
        currentUser = nil
        isLoggedIn = false
    }
}
