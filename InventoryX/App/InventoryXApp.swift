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
 
 */

import SwiftUI
import RealmSwift

/*
 If you're debugging and want to add sample data, add this to the view.
 
 .onAppear {
     Task {
         try await RealmActor().setUpForDebug()
     }
 }
 
 */

@main
struct InventoryXApp: SwiftUI.App {
    let migrator: RealmMigrator = RealmMigrator()
    
    var body: some Scene {
        WindowGroup {
            ResponsiveView { props in
                RootView(uiProperties: props)
            }
        }
    }
}




