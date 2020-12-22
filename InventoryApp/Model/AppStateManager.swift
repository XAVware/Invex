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
    @Published var isShowingMenu: Bool                  = false
    @Published var isShowingConfirmation: Bool          = false
    @Published var currentDisplayState: DisplayState    = .makeASale
    
    @Published var itemList: [Item]                     = []
    @Published var beverageList: [Item]                 = []
    @Published var foodSnackList: [Item]                = []
    @Published var frozenList: [Item]                   = []
    @Published var otherList: [Item]                    = []
    
    func beginCheckout() {
        withAnimation {
            self.isShowingConfirmation = true
        }
    }
    
    func restockItem(itemIndex: Int, quantity: Int) {
        let tempItem = self.itemList[itemIndex]
        let newQuantity = tempItem.onHandQty + quantity
        let predicate = NSPredicate(format: "name CONTAINS %@", tempItem.name)
        let config = Realm.Configuration(schemaVersion: 1)
        do {
            let realm = try Realm(configuration: config)
            let result = realm.objects(Item.self).filter(predicate)
            for item in result {
                try realm.write ({
                    item.onHandQty = newQuantity
                    realm.add(item)
                })
            }
        } catch {
            print(error.localizedDescription)
        }
    
    }
    
    func deleteItem(atOffsets offsets: IndexSet) {
        guard let itemIndex = offsets.first else {
            print("Unable to retrieve selected item index. See deleteItem() -- Returning")
            return
        }
        
        let selectedItem = self.itemList[itemIndex]
        
        
        let config = Realm.Configuration(schemaVersion: 1)
        do {
            let realm = try Realm(configuration: config)
            let result = realm.objects(Item.self)
            
            for item in result {
                if item.name == selectedItem.name {
                    try realm.write ({
                        realm.delete(item)
                    })
                    self.getAllItems()
                    return
                }
            }
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    
    
    func changeDisplay(to newDisplayState: DisplayState) {
        withAnimation {
            self.isShowingMenu.toggle()
        }
        guard newDisplayState != currentDisplayState else { return }
        self.currentDisplayState = newDisplayState
        self.getAllItems()
    }
    
    func getItemList(forType type: String) -> [Item] {
        var tempList: [Item] = []
        
        let predicate = NSPredicate(format: "type CONTAINS %@", type)
        let realm = try! Realm()
        let result = realm.objects(Item.self).filter(predicate)
        for item in result {
            tempList.append(item)
        }
        
        return tempList
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
    
    func clearLists() {
        self.itemList.removeAll()
        self.beverageList.removeAll()
        self.foodSnackList.removeAll()
        self.frozenList.removeAll()
        self.otherList.removeAll()
    }
    
    
    func getAllItems() {
        self.clearLists()
        
        var tempItemList: [Item] = []
        var tempBeverageList: [Item] = []
        var tempFoodSnackList: [Item] = []
        var tempFrozenList: [Item] = []
        var tempOtherList: [Item] = []
        
        let config = Realm.Configuration(schemaVersion: 1)
        do {
            let realm = try Realm(configuration: config)
            let result = realm.objects(Item.self)
            for item in result {
                tempItemList.append(item)
                //self.itemList.append(item)
                
                switch item.type {
                case "Beverage":
                    tempBeverageList.append(item)
//                    beverageList.append(item)
                case "Food / Snack":
                    tempFoodSnackList.append(item)
//                    foodSnackList.append(item)
                case "Frozen":
                    tempFrozenList.append(item)
//                    frozenList.append(item)
                default:
                    tempOtherList.append(item)
//                    otherList.append(item)
                }
            }
        } catch {
            print("Triggered In Get all")
            
            print(error.localizedDescription)
        }
        
        self.itemList = tempItemList
        self.beverageList = tempBeverageList
        self.foodSnackList = tempFoodSnackList
        self.frozenList = tempFrozenList
        self.otherList = tempOtherList
    }
    
}
