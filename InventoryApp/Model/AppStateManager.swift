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
//            let newData = datatype()
//            newData.name = self.name
//            newData.age = self.age
            try realm.write({
//                realm.add(newData)
                print("Success")
            })
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
