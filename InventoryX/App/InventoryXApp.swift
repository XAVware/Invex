//
//  InventoryXApp.swift
//  InventoryX
//
//  Created by Smetana, Ryan on 4/19/23.
//

import SwiftUI
import RealmSwift

@main
struct InventoryXApp: SwiftUI.App {
    let migrator: RealmMigrator = RealmMigrator()
    @ObservedResults(CategoryEntity.self) var categories
    @ObservedResults(UserEntity.self) var users
//    @StateObject var userManager: UserManager = UserManager()
    
    var body: some Scene {
        WindowGroup {
            if categories.count == 0 && users.count == 0 {
                OnboardingView()
//                    .environmentObject(userManager)
            } else {
                ContentView()
                    .onAppear {
                        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.path)
                        UserDefaults.standard.setValue(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
                    }
            }
        }
    } //: Body
}
