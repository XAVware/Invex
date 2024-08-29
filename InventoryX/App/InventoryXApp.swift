//
//  InventoryXApp.swift
//  InventoryX
//
//  Created by Smetana, Ryan on 4/19/23.
//

/*
 User defined build settings:
 DISABLE_DIAMOND_PROBLEM_DIAGNOSTIC = YES was added to resolve an error of "Showing All Issues Swift package target 'Realm' is linked as a static library by 'InventoryX' and 'Realm', but cannot be built dynamically because there is a package product with the same name."
 
 .onAppear {
    // To fix an issue at some point I added this.
    UserDefaults.standard.setValue(true, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
 
 }
 
 If you're debugging and want to add sample data, add this to the view.
 
 .onAppear {
     Task {
         try await RealmActor().setUpForDebug()
     }
 }
 
 */

import SwiftUI
import RealmSwift

@main
struct InventoryXApp: SwiftUI.App {
    let migrator: RealmMigrator = RealmMigrator()

    init() {
        UIColor.classInit
        UIPageControl.appearance().currentPageIndicatorTintColor = .accent.withAlphaComponent(0.8)
        UIPageControl.appearance().pageIndicatorTintColor = .accent.withAlphaComponent(0.2)
    }
    
    var body: some Scene {
        WindowGroup {
            RootView()
//                .onAppear {
//                    Task {
//                        try await RealmActor().setUpForDebug()
////                        let h = AuthService.shared.hashString("1234")
////                        await AuthService.shared.savePasscode(hash: h)
//                        AuthService.shared.exists = true
//                        
//                    }
//                }
        }
    }
}
