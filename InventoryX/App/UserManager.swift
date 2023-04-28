//
//  UserManager.swift
//  InventoryX
//
//  Created by Smetana, Ryan on 4/27/23.
//

import SwiftUI
import RealmSwift

class UserManager: ObservableObject {
//    @Published var requireOnboarding: Bool = true
    @Published var isLoggedIn: Bool = false
    @Published var currentUser: UserEntity?
    
//    @ObservedResults(CategoryEntity.self) var categories
//
    init() {
        if let firstUser = try! Realm().objects(UserEntity.self).first {
            print("User Exists")
            currentUser = firstUser
        }
    }
    
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
