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
    //    @StateObject var userManager: UserManager = UserManager()
    @StateObject var navMan: NavigationManager = NavigationManager()
    
    let migrator: RealmMigrator = RealmMigrator() // Storing like this is bad for memory. This only needs to run once.
    @ObservedResults(CategoryEntity.self) var categories
    @ObservedResults(UserEntity.self) var users
    
    var body: some Scene {
        WindowGroup {
            if categories.count == 0 && users.count == 0 {
                OnboardingView()
//                    .environmentObject(userManager)
            } else {
                GeometryReader { geo in
                    ContentView()
                        .environmentObject(navMan)
                        .onAppear {
                            print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.path)
                            UserDefaults.standard.setValue(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
//                            navMan.setup(screenWidth: geo.size.width)
                            print(geo.safeAreaInsets.top)
                        }
                } //: Geometry Reader
            }
        }
    } //: Body
}
