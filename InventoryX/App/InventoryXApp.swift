//
//  InventoryXApp.swift
//  InventoryX
//
//  Created by Smetana, Ryan on 4/19/23.
//

/// To Do List
/// - Apple changes from version 1

/// - Sort/Filter Item List
/// - Pass width to cart and menu enums to determine states for device size
/// - Make detailViews Generic
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
//            .onAppear {
//                Task {
//                    try await RealmActor().setUpForDebug()
//                }
//            }
        }
    }
}
