//
//  ContentView.swift
//  InventoryX
//
//  Created by Smetana, Ryan on 4/24/23.
//

import SwiftUI
import RealmSwift

// 11 Inch iPad (Landscape)
// Width: 1194
// Height: 790

struct ContentView: View {
    @ObservedResults(CategoryEntity.self) var categories
    
    @State var selectedCategory: CategoryEntity?
    @State var currentDisplay: DisplayStates = .makeASale
    @State var menuIsHidden: Bool = false
    
    var body: some View {
        GeometryReader { geo in
            HStack(spacing: 0) {
                if !menuIsHidden {
                    MenuView(currentDisplay: self.$currentDisplay)
                        .frame(maxWidth: geo.size.width * 0.15)
                }
                navContent
            } //: HStack
            .background(primaryBackground)
            .onChange(of: categories) { newCategories in
                guard selectedCategory == nil, newCategories.count > 0 else { return }
                selectedCategory = newCategories.first!
            }
        }
    } //: Body
    
    @ViewBuilder private var navContent: some View {
        switch currentDisplay {
        case .makeASale:
            MakeASaleView(menuIsHidden: $menuIsHidden)
        case .addInventory:
            RestockView()
        case .inventoryList:
            InventoryView()
        case .salesHistory:
            SalesHistoryView()
        case .inventoryStatus:
            InventoryStatusView()
        case .settings:
            SettingsView()
        }
    } //: Nav Content
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .modifier(PreviewMod())
    }
}
