//
//  AppStateManager.swift
//  InventoryApp
//
//  Created by Ryan Smetana on 12/9/20.
//

import SwiftUI
import RealmSwift

class AppStateManager: ObservableObject {
    
    enum DisplayState {
        case makeASale, addInventory, inventoryList
    }
    
    var hapticImpact = UIImpactFeedbackGenerator(style: .heavy)
    @Published var isShowingMenu: Bool      = false
    @Published var currentDisplayState: DisplayState = .makeASale
    
    @Published var itemList: [Item]         = []
    @Published var beverageList: [Item]     = []
    @Published var foodSnackList: [Item]    = []
    @Published var frozenList: [Item]       = []
    @Published var otherList: [Item]        = []
    
    
    
    func changeDisplay(to newDisplayState: DisplayState) {
        withAnimation {
            self.isShowingMenu.toggle()
        }
        guard newDisplayState != currentDisplayState else { return }
        self.currentDisplayState = newDisplayState
        self.getAllItems()
    }
    
    
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
            try realm.write ({
                realm.add(newItem)
            })
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    func getAllItems() {
        self.itemList.removeAll()
        self.beverageList.removeAll()
        self.foodSnackList.removeAll()
        self.frozenList.removeAll()
        self.otherList.removeAll()
        
        let config = Realm.Configuration(schemaVersion: 1)
        do {
            let realm = try Realm(configuration: config)
            let result = realm.objects(Item.self)
            for item in result {
                itemList.append(item)
                
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
    
}
