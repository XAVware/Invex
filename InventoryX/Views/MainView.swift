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
struct MainView: View {
    @EnvironmentObject var userManager: UserManager
    @ObservedResults(CategoryEntity.self) var categories
    
    @StateObject var cart = Cart()
    @State var columnVisibility: NavigationSplitViewVisibility = .automatic
    
    @State var selectedCategory: CategoryEntity?
    @State var currentDisplay: DisplayStates = .inventoryList
    
    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    
                    ZStack {
                        Capsule()
                            .frame(height: 30)
                            .foregroundColor(Color(XSS.S.color90))
                            .frame(maxWidth: geo.size.width / 4)
                        
                        HStack(spacing: 16) {
                            Image(systemName: "magnifyingglass")
                            Text("Search...")
                        }
                        .modifier(TextMod(.footnote, .regular, .gray))
                    }
                    .padding()
                    .edgesIgnoringSafeArea(.top)
                    
                    Spacer()
                } //: HStack
                .padding()
                .frame(maxHeight: geo.size.height * 0.05)
                .background(Color(XSS.S.color20))
                .overlay(logo, alignment: .topLeading)
                
                HStack(spacing: 0) {
                    MenuView(currentDisplay: self.$currentDisplay)
                        .frame(maxWidth: geo.size.width * 0.15)
                    
                    navContent
                } //: HStack
                .background(Color(XSS.S.color20))
            } //: VStack
            .onAppear {
                guard let defaultCategory = categories.first else { return }
                selectedCategory = defaultCategory
            }
            .onChange(of: categories) { newCategories in
                guard selectedCategory == nil, newCategories.count > 0 else { return }
                selectedCategory = newCategories.first!
            }
        }
    } //: Body
    
    private var logo: some View {
        HStack(spacing: 0) {
            Text("Inventory")
                .modifier(TextMod(.title, .semibold, Color(XSS.S.color30)))
                .offset(y: -2)
            Text("X")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .italic()
        } //: HStack
        .foregroundColor(Color(XSS.S.color30))
        .padding()
        .edgesIgnoringSafeArea(.top)
    } //: Logo
    
    private var navSplitViewStyle: some View {
        GeometryReader { geo in
            NavigationSplitView(columnVisibility: .constant(.doubleColumn)) {
                MenuView(currentDisplay: self.$currentDisplay)
                    .navigationSplitViewColumnWidth(ideal: geo.size.width / 6)
            } detail: {
                navContent
            }
            .navigationSplitViewStyle(.prominentDetail)
            .onAppear {
                //                columnVisibility = .detailOnly
                guard let defaultCategory = categories.first else { return }
                selectedCategory = defaultCategory
            }
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
                    if category.items.count > 0 {
                        CategorySelector(selectedCategory: self.$selectedCategory)
                    }
                } else {
                    ProgressView()
                }
            } //: VStack
            
        case .addInventory:
            RestockView()
//            AddInventoryView()
        case .inventoryList:
            InventoryView()
        case .salesHistory:
            SalesHistoryView()
        case .inventoryStatus:
            InventoryStatusView()
        }
    } //: Nav Content
    
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .modifier(PreviewMod())
    }
}



struct CategorySelector: View {
    @ObservedResults(CategoryEntity.self) var categories
    @Binding var selectedCategory: CategoryEntity?
    
    enum Style { case scrollingTab, scrollingButton }
    let style: Style = .scrollingButton
    
    var body: some View {
        switch style {
        case .scrollingTab:
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 2) {
                    ForEach(categories) { category in
                        Button {
                            selectedCategory = category
                        } label: {
                            Text(category.name)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                            
                                .opacity(selectedCategory == category ? 1.0 : 0.65)
                        }
                        .frame(minWidth: 150)
                        .background(selectedCategory == category ? Color.white : Color(UIColor.systemGray4))
                        .cornerRadius(15, corners: [.bottomLeft, .bottomRight])
                        
                        Divider()
                            .background(Color.black)
                            .padding(.vertical, 4)
                    }
                    
                } //: HStack
            } //: Scroll
            .frame(maxWidth: .infinity, maxHeight: 40)
            .background(Color(UIColor.systemGray4).frame(maxWidth: .infinity))
            
        case .scrollingButton:
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 2) {
                    ForEach(categories) { category in
                        Button {
                            selectedCategory = category
                        } label: {
                            Text(category.name)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .foregroundColor(selectedCategory == category ? Color(XSS.S.color10) : Color(XSS.S.color90))
                            
                        }
                        .frame(minWidth: 150)
                        .background(selectedCategory == category ? Color(XSS.S.color80) : Color(XSS.S.color40))
                        .cornerRadius(15, corners: [.bottomLeft, .bottomRight])
                        
                    }
                    
                } //: HStack
            } //: Scroll
            .frame(maxWidth: .infinity, maxHeight: 40)
            .background(.clear)
        }
    }
}

