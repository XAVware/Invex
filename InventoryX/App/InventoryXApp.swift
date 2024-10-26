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

    init() {
//        UIColor.classInit
//        UINavigationBar.appearance().backgroundColor = UIColor(resource: .bg)
         /*
          TODO: Document this in LazySplitX
          I added this to change the color of the page indicator dots in a Tab View Page style. It seems to cause the default tinting of all components, including buttons, table headers, and LazySplitX toolbar buttons, to revert back to blue.
          
          UIPageControl.appearance().currentPageIndicatorTintColor = .accent.withAlphaComponent(0.8)
          UIPageControl.appearance().pageIndicatorTintColor = .accent.withAlphaComponent(0.2)
          
          Changing the navigation bar background color with this:
          
          UINavigationBar.appearance().backgroundColor = UIColor(resource: .bg)
          
          means you need to add .tint(.accent) to LSXView
          */
         
    }
    
    var body: some Scene {
        WindowGroup {
            TabRoot()
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
