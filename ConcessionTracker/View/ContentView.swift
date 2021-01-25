//
//  ContentView.swift
//  ConcessionTracker
//
//  Created by Ryan Smetana on 1/20/21.
//

import SwiftUI
import RealmSwift

struct ContentView: View {
    @State var displayState: DisplayStates      = .makeASale
    @StateObject var cart                       = Cart()
    
    var body: some View {
        ZStack {
            switch self.displayState {
            case .makeASale:
                ZStack {
                    MakeASaleView(cart: self.cart)
                    CartView(cart: self.cart)
                }
            case .addInventory:
                AddInventoryView()
            }
            
            if !self.cart.isConfirmation {
                MenuView(displayState: self.$displayState)
            }
        } //: ZStack
    }
    
    init() {
        let config = Realm.Configuration(
            schemaVersion: 1,
            
            migrationBlock: { migration, oldSchemaVersion in
                if (oldSchemaVersion < 1) {
                    migration.enumerateObjects(ofType: Item.className()) { (oldObject, newObject) in
                        
                    }
                    migration.enumerateObjects(ofType: Sale.className()) { oldObject, newObject in
                        
                    }
                }
            })
        Realm.Configuration.defaultConfiguration = config
        do {
            _ = try Realm()
        } catch let error as NSError {
            print("Error initializing realm with error-- \(error.localizedDescription)")
        }
        
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(Color("ThemeColor"))
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.black], for: .normal)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        UITableView.appearance().backgroundColor = .clear
        UITableViewCell.appearance().backgroundColor = .clear
        UITableView.appearance().separatorColor = .white
    }
}
