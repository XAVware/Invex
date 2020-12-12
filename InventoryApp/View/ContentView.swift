//
//  ContentView.swift
//  InventoryApp
//
//  Created by Ryan Smetana on 12/9/20.
//

import SwiftUI
import RealmSwift

struct ContentView: View {
    @StateObject var appManager = AppStateManager()
    @StateObject var cart = Cart()
    
    
    
    var body: some View {
        NavigationView {
            
            ZStack {
                
                VStack(spacing: 0) {
                    
                    HeaderView(appManager: self.appManager)
     
                    switch self.appManager.currentDisplayState {
                    case .makeASale:
                        MakeASaleView(appManager: self.appManager, cart: self.cart)
                    case .addInventory:
                        AddInventoryView(appManager: self.appManager)
                    case .inventoryList:
                        InventoryListView(appManager: self.appManager)
                    }
                    
                    
                } //: VStack used to keep header above all pages
                
                
                MenuView(appManager: self.appManager) //Menu should always be at top of ZStack
            }
            .onAppear {
                self.appManager.getAllItems()
            }
            
            
            .navigationBarHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    } //: Body
    
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewLayout(.fixed(width: 1024, height: 786))
    }
}



