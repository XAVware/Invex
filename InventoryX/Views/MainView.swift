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
    @State var currentDisplay: DisplayStates = .makeASale
    
    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 0) {
                HStack(alignment: .center) {
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
                    
                    Spacer()
                    
                    HStack(spacing: 16) {
                        Text("Ryan")
                            .modifier(TextMod(.title3, .medium, Color(XSS.S.color80)))
                        
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 32, height: 32)
                    } //: HStack
                    .foregroundColor(Color(XSS.S.color80))
                    .padding()
                    .edgesIgnoringSafeArea(.top)
                } //: HStack
                .padding()
                .frame(maxHeight: geo.size.height * 0.05)
                .background(Color(XSS.S.color20))
                
                HStack(spacing: 0) {
                    MenuView(currentDisplay: self.$currentDisplay)
                        .frame(maxWidth: geo.size.width * 0.23)
                    VStack(spacing: 0) {
                        if let category = selectedCategory {
                            MakeASaleView(selectedCategory: category)
                                .padding()
                                .background(Color(XSS.S.color80))
                                .cornerRadius(20, corners: .topLeft)
                            
                            CategorySelector(selectedCategory: self.$selectedCategory)
                        } else {
                            ProgressView()
                        }
                    } //: VStack
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
    
    private var navSplitViewStyle: some View {
        GeometryReader { geo in
            NavigationSplitView(columnVisibility: .constant(.doubleColumn)) {
                MenuView(currentDisplay: self.$currentDisplay)
                    .navigationSplitViewColumnWidth(ideal: geo.size.width / 6)
                    .onTapGesture {
                        print(geo.size.width)
                    }
            } detail: {
                navContent
                    .onTapGesture {
                        print(geo.size.width)
                    }
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
            if let category = selectedCategory {
                MakeASaleView(selectedCategory: category)
                CategorySelector(selectedCategory: self.$selectedCategory)
            } else {
                ProgressView()
            }
            
        case .addInventory:
            AddInventoryView()
        case .inventoryList:
            InventoryListView()
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

struct MakeASaleView: View {
    @ObservedRealmObject var selectedCategory: CategoryEntity
    @State var counter: Int = 0
    
    var body: some View {
        HStack {
            VStack(spacing: 0) {
                if selectedCategory.items.count > 0 {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 140))], spacing: 0) {
                        ForEach(selectedCategory.items) { item in
                            Button {
                                //                                cart.addItem(item)
                            } label: {
                                Text(item.name)
                                    .font(.system(size: 18, weight: .semibold, design:.rounded))
                                    .foregroundColor(.black)
                                    .frame(width: 140, height: 80)
                                    .background(.blue)
                            }
                            .cornerRadius(9)
                            .padding()
                            .shadow(radius: 8)
                        } //: ForEach
                    } //: LazyVGrid
                    Spacer()
                } else {
                    VStack {
                        Text("No Items in this category yet.")
                        addItemButton
                            .modifier(RoundedButtonMod())
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } //: If-Else
            } //: VStack
        } //: HStack
    } //: Body
    
    private var addItemButton: some View {
        Button {
            let item = InventoryItemEntity()
            item.name = "Item \(counter)"
            item.retailPrice = 1.00
            
            do {
                let realm = try Realm()
                try realm.write {
                        $selectedCategory.items.append(item)
                        print("Item Added: \n \(item)")
                    
                }
            } catch {
                print(error.localizedDescription)
            }
            counter += 1
        } label: {
            Text("Add Item")
        }
        .modifier(RoundedButtonMod())
    } //: Add Item View
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

struct MenuView: View {
    @Binding var currentDisplay: DisplayStates
    
    var body: some View {
        VStack {
            ForEach(DisplayStates.allCases, id: \.self) { displayState in
                Button {
                    currentDisplay = displayState
                } label: {
                    Text("\(displayState.menuButtonText)")
                        .foregroundColor(Color(XSS.S.color80))
                        .frame(maxWidth: .infinity)
                }
                .frame(height: 50)
            }
            
            Button {
                deleteAllFromRealm()
            } label: {
                Text("Delete Everything")
                    .foregroundColor(Color(XSS.S.color80))
            }
            .frame(height: 40)
            Spacer()
            Button {
                deleteAllFromRealm()
            } label: {
                Text("Sign Out")
                    .foregroundColor(Color(XSS.S.color80))
            }
            .frame(height: 40)
        } //: VStack
        .padding()
        .background(Color(XSS.S.color20))
        .modifier(TextMod(.title3, .semibold))
        .edgesIgnoringSafeArea(.bottom)
    }
    
    func deleteAllFromRealm() {
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
    }
}
