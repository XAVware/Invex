//
//  AppStateManager.swift
//  InventoryApp
//
//  Created by Ryan Smetana on 12/9/20.
//

import SwiftUI
import RealmSwift

class AppStateManager: ObservableObject {
    var hapticImpact = UIImpactFeedbackGenerator(style: .heavy)
    @Published var isShowingMenu: Bool      = false
    @Published var isShowingAddItem: Bool   = false
    
    @Published var beverageList: [Item]     = []
    @Published var foodSnackList: [Item]    = []
    @Published var frozenList: [Item]       = []
    @Published var otherList: [Item]        = []
    
    
    func toggleMenu() {
        self.hapticImpact.impactOccurred()
        withAnimation {
            self.isShowingMenu.toggle()
        }
    }
    
    func createNewItem(newItem: Item) {
        let config = Realm.Configuration(schemaVersion: 1)
        do {
            let realm = try Realm(configuration: config)
            try realm.write({
                realm.add(newItem)
                print("Success")
            })
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func getAllItems() {
        let config = Realm.Configuration(schemaVersion: 1)
        do {
            let realm = try Realm(configuration: config)
            let result = realm.objects(Item.self)
            for item in result {
                switch item.type {
                case "Beverage":
                    beverageList.append(item)
                case "Food / Snack":
                    foodSnackList.append(item)
                case "Frozen":
                    frozenList.append(item)
                default:
                    otherList.append(item)
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func goToAddInventory() {
        self.hapticImpact.impactOccurred()
        
        self.isShowingAddItem.toggle()
        self.toggleMenu()
        
    }
    
    func goToMakeASale() {
        self.hapticImpact.impactOccurred()
        self.isShowingAddItem.toggle()
        self.toggleMenu()
    }
}
