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
    
    @State var isShowingKeyboard: Bool = false
    
    var body: some View {
        ZStack {
            
            ScrollView(self.isShowingKeyboard ? .vertical : []) {
                
                VStack(spacing: 0) {
                    
                    HeaderView(appManager: self.appManager)
                    
                    switch self.appManager.currentDisplayState {
                    
                    case .makeASale:
                        ZStack {
                            MakeASaleView(appManager: self.appManager, cart: self.cart)
                            
                            CartView(cart: self.cart)
                        }
                        
                    case .addInventory:
//                        AddInventoryView(appManager: self.appManager)
                        NewAddInventoryView()
                    case .inventoryList:
//                        InventoryListView(appManager: self.appManager)
                        NewInventoryListView()
                        
                    case .salesHistory:
                        SalesHistoryView(appManager: self.appManager)
                    }
                    
                } //: VStack used to keep header above all pages
                
            } //: Scroll
            
            MenuView(appManager: self.appManager)
            
        } //: ZStack
        .onAppear {
            self.appManager.getAllItems()
            
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { (not) in
                self.isShowingKeyboard = true
            }
            
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardDidHideNotification, object: nil, queue: .main) { (not) in
                self.isShowingKeyboard = false
            }
        }
        
        
    } //: Body
    
    init() {
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(named: "ColorWatermelonDark")
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.black], for: .normal)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        UITextField.appearance().textColor = .black
        UITableView.appearance().backgroundColor = .clear
        UITableViewCell.appearance().backgroundColor = .clear
        UITableView.appearance().separatorColor = .white
    }
    
}


