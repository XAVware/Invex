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
    @State var currentDisplay: DisplayStates = .dashboard
    @State var menuIsHidden: Bool = false
    @State var menuVisibility: NavigationSplitViewVisibility = .detailOnly
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                detailView
                
                NavigationSplitView(columnVisibility: $menuVisibility) {
                    menu
                        .navigationSplitViewColumnWidth(0.2 * geo.size.width)
                } detail: {
                    navContent
                }
                .tint(menuVisibility == .all ? secondaryBackground : primaryBackground)
                .navigationSplitViewStyle(.prominentDetail)
                .onChange(of: categories) { newCategories in
                    guard selectedCategory == nil, newCategories.count > 0 else { return }
                    selectedCategory = newCategories.first!
                }
                .onChange(of: menuVisibility) { newValue in
                    print(newValue)
                }
            }
            
//            HStack(spacing: 0) {
//                if !menuIsHidden {
//                    MenuView(currentDisplay: self.$currentDisplay)
//                        .frame(maxWidth: geo.size.width * 0.15)
//                }
//                navContent
//            } //: HStack
//            .background(primaryBackground)
//            .onChange(of: categories) { newCategories in
//                guard selectedCategory == nil, newCategories.count > 0 else { return }
//                selectedCategory = newCategories.first!
//            }
        } //: Geometry Reader
    } //: Body
    
    @ViewBuilder private var navContent: some View {
        switch currentDisplay {
        case .dashboard:
            DashboardView()
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
    
    
    @ViewBuilder private var detailView: some View {
        Text("Detail")
    } //: Nav Detail
    
    @ViewBuilder private var menu: some View {
        VStack {
            HStack(spacing: 16) {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                VStack {
                    Text("Ryan")
                        .modifier(TextMod(.title3, .medium, secondaryBackground))
                    Text("Admin")
                        .modifier(TextMod(.footnote, .regular, lightFgColor))
                }
                
            } //: HStack
            .foregroundColor(secondaryBackground)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading)
            
            Divider()
                .background(secondaryBackground)
                .padding(.vertical)
            
            ForEach(DisplayStates.allCases, id: \.self) { displayState in
                Button {
                    currentDisplay = displayState
                } label: {
                    Image(systemName: displayState.iconName)
                        .imageScale(.medium)
                        .bold()
                    
                    Text("\(displayState.menuButtonText)")
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding()
                .frame(height: 50)
                .overlay(currentDisplay == displayState ? lightFgColor.opacity(0.3).cornerRadius(5).padding(.horizontal, 4) : nil)
            }
            
            Spacer()
            
            Button {
                
            } label: {
                Image(systemName: "rectangle.portrait.and.arrow.forward")
                    .imageScale(.medium)
                    .bold()
                
                Text("Sign Out")
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding()
            .frame(height: 50)
        } //: VStack
        .background(primaryBackground)
        .modifier(TextMod(.title3, .semibold, lightFgColor))
    } //: Menu
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .modifier(PreviewMod())
    }
}
