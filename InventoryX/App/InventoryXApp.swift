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


/*
 PointOfSaleViewModel is initialized in the root so a user's cart is not lost when
 they switch screens. If it were initialized in PointOfSaleView, it will re-initialize
 every time the user goes to the point of sale view, resetting the cart.
 
 Menu shouldn't be open while cart is a sidebar and vice versa.
 
 Future features:
 - Try to find pattern in pricing/percentage data added by user and change
 pickers/sliders to behave accordingly
 -> i.e. if all prices end in 0, price pickers should not default to increments
 less than 0.1
 */

import SwiftUI
import RealmSwift

@main
struct InventoryXApp: SwiftUI.App {
    @Environment(\.verticalSizeClass) var vSize
    let migrator: RealmMigrator = RealmMigrator()
    
    
    var body: some Scene {
        WindowGroup {
            TabRoot()
        }
    }
}
