//
//  ContentView.swift
//  InventoryApp
//
//  Created by Ryan Smetana on 12/9/20.
//

import SwiftUI
import RealmSwift


enum DisplayStates {
    case makeASale, addInventory, inventoryList, salesHistory, inventoryStatus
}

struct ContentView: View {
    
    @State var displayState: DisplayStates          = .makeASale

    @StateObject var cart = Cart()
    
    @State var test: Bool = true
    var body: some View {
        ZStack {

            switch self.displayState {
            case .makeASale:
                ZStack {
                    MakeASaleView(cart: self.cart)

                    CartView(cart: self.cart)
                }
            case .addInventory:
                NewAddInventoryView()
            case .inventoryList:
                NewInventoryListView()
            case .salesHistory:
                SalesHistoryView()
            case .inventoryStatus:
                InventoryStatusView()
            }

            if !self.cart.isConfirmation {
                NewMenuView(displayState: self.$displayState)
            }

        }
        .edgesIgnoringSafeArea(.all)
        
    } //: Body
    
    init() {        
        let config = Realm.Configuration(
            // Set the new schema version. This must be greater than the previously used
            // version (if you've never set a schema version before, the version is 0).
            schemaVersion: 2,
            
            // Set the block which will be called automatically when opening a Realm with
            // a schema version lower than the one set above
            migrationBlock: { migration, oldSchemaVersion in
                // We haven’t migrated anything yet, so oldSchemaVersion == 0
                if (oldSchemaVersion < 2) {
                    migration.enumerateObjects(ofType: Item.className()) { (oldObject, newObject) in
                        
                    }
                    migration.enumerateObjects(ofType: Sale.className()) { oldObject, newObject in
                        // No-op.
                        // dynamic properties are defaulting the new column to true
                        // but the migration block is still needed
                    }
                }
            })
        
        // Tell Realm to use this new configuration object for the default Realm
        Realm.Configuration.defaultConfiguration = config
        
        // Now that we've told Realm how to handle the schema change, opening the file
        // will automatically perform the migration
        do {
            _ = try Realm()
        } catch let error as NSError {
            print("Error initializing realm with error-- \(error.localizedDescription)")
            // print error
        }
        
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(Color(hex: "365cc4"))
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.black], for: .normal)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        UITextField.appearance().textColor = .black
        UITableView.appearance().backgroundColor = .clear
        UITableViewCell.appearance().backgroundColor = .clear
        UITableView.appearance().separatorColor = .white
        
    }
    
}


