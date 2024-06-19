//
//  InventoryXApp.swift
//  InventoryX
//
//  Created by Smetana, Ryan on 4/19/23.
//

/// To Do List
/// - Sort/Filter Item List
/// - Pass width to cart and menu enums to determine states for device size
/// [x] Make detailViews Generic (v1.1)
/// - Improve animations and UI of cart and menu
/// - Receive inventory
/// - Implement UIFeedback Service for Alerts
/// - Department default markup
/// - Item cost, margin, markup
/// - Amount tendered
/// - change item department
/// - Lock screen dismisses on orientation change
/// - Table row background
/// - Move detail views from sheets to side like cart
///


// MARK: - Future Features
/// - Sales History
/// - Print receipt
/// - CSV Upload
/// - Look up item data from UPC with camera
/// - Option to change color theme
/// - Email inventory report
/// - Multiple accounts

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
 Ability to drag the cart side view. Change size and capacity of point of sale view while the cart is dragging. If the user drags it to a certain spot and leaves it, that's how they prefer the cart to appear on their device and it should be saved in user defaults.
 */

/*
 If you're debugging and want to add sample data, add this to the view.
 
 .onAppear {
     Task {
         try await RealmActor().setUpForDebug()
     }
 }
 
 */

/*
 Version 1.2
 - Finished developing LazySplit which resulted in:
    - Removed ResponsiveView
    - No longer need to track if menu is open or not. LazyNavView's .prominentDetail style won't compress the button grid.
 
 - Added item count to cart button so the user is aware of what is happening on compact screens.
 - Add landing page to onboarding sequence.
 - Fix bug where lock screen dismissed on orientation change.
 - Improve UI of InventoryListView
 - Minor Realm performance improvements
 
 Removed:
 - ResponsiveView
 - MenuState
 - OnboardingState
 - GlowingOutlineMod
 - SecondaryButtonMod
 - TitleMod
 - PaneOutlineMod
 - MenuButtonMod
 - ColumnHeaderModel
 */

@main

struct InventoryXApp: SwiftUI.App {
    let migrator: RealmMigrator = RealmMigrator()
    
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
