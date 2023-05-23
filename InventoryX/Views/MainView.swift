//
//  MainView.swift
//  InventoryX
//
//  Created by Smetana, Ryan on 4/24/23.
//

import SwiftUI
import RealmSwift

// 11 Inch iPad (Landscape)
// Width: 1194
// Height: 790

//@MainActor class MainViewModel: ObservedObject {
//    
//}

struct MainView: View {
    @EnvironmentObject var userManager: UserManager
    @ObservedResults(CategoryEntity.self) var categories
    
    @StateObject var cart = Cart()
    @State var columnVisibility: NavigationSplitViewVisibility = .automatic
    
    @State var selectedCategory: CategoryEntity?
    @State var currentDisplay: DisplayStates = .makeASale
    
    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    MenuView(currentDisplay: self.$currentDisplay)
                        .frame(maxWidth: geo.size.width * 0.15)
                    
                    navContent
                } //: HStack
                .background(Color(XSS.S.color20))
            } //: VStack
            .onChange(of: categories) { newCategories in
                guard selectedCategory == nil, newCategories.count > 0 else { return }
                selectedCategory = newCategories.first!
            }
        }
    } //: Body
    
    private var navSplitViewStyle: some View {
        GeometryReader { geo in
            NavigationSplitView(columnVisibility: .constant(.doubleColumn)) {
                MenuView(currentDisplay: self.$currentDisplay)
                    .navigationSplitViewColumnWidth(ideal: geo.size.width / 6)
                
            } detail: {
                navContent
            }
            .navigationSplitViewStyle(.prominentDetail)
            .onChange(of: categories) { newCategories in
                guard selectedCategory == nil, newCategories.count > 0 else { return }
                selectedCategory = newCategories.first!
            }
        }
    } //: Nav Split View Style
    
    @ViewBuilder private var navContent: some View {
        switch currentDisplay {
        case .makeASale:
            VStack(spacing: 0) {
                if let category = selectedCategory {
                    MakeASaleView(selectedCategory: category)
                    CategorySelector(selectedCategory: self.$selectedCategory)
                } else {
                    ProgressView()
                }
            } //: VStack
            
        case .addInventory:
            RestockView()
        case .inventoryList:
            InventoryView()
        case .salesHistory:
            SalesHistoryView()
        case .inventoryStatus:
            Text("Status")
//            InventoryStatusView()
        }
    } //: Nav Content
    
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .modifier(PreviewMod())
    }
}
