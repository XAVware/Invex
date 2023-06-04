//
//  UserManager.swift
//  InventoryX
//
//  Created by Smetana, Ryan on 4/27/23.
//

import SwiftUI
import RealmSwift

class UserManager {
//    @Published var isLoggedIn: Bool = false
    var currentUser: UserEntity?
//
//    var currentUserName: String = ""
    
    static let shared: UserManager = UserManager()
    
    private init() { }
    
    func loginUser(_ user: UserEntity) {
        currentUser = user
//        isLoggedIn = true
    }
    
    func getLoggedInUserName() -> String {
        guard let user = currentUser else {
            print("No User")
            return "Err"
        }
        return user.profileName
    }
    
    func signOut() {
//        currentUser = nil
//        isLoggedIn = false
    }
}
