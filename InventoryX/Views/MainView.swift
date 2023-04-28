//
//  MainView.swift
//  InventoryX
//
//  Created by Smetana, Ryan on 4/24/23.
//

import SwiftUI
import RealmSwift


struct MainView: View {
    @EnvironmentObject var userManager: UserManager
    @ObservedResults(CategoryEntity.self) var categories
    
    @StateObject var cart = Cart()
    @State var columnVisibility: NavigationSplitViewVisibility = .automatic
    
    @State var selectedCategory: CategoryEntity?
    @State var currentDisplay: DisplayStates = .makeASale
    
    
    
    
    var body: some View {
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

    } //: Body
    
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
    
    enum Style { case scrolling }
    let style: Style = .scrolling
    
    var body: some View {
        switch style {
        case .scrolling:
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 2) {
                    ForEach(categories) { category in
                        Button {
                            selectedCategory = category
                        } label: {
                            Text(category.name)
                                .padding(10)
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
                }
                .frame(height: 40)
                
                Divider().padding(.horizontal).tint(Color(XSS.S.color80))
            }
            
            Button {
                deleteAllFromRealm()
            } label: {
                Text("Delete Everything")
            }
            .frame(height: 40)
            Spacer()
        } //: VStack
        .background(Color(XSS.S.color20))
        .modifier(TextMod(.headline, .semibold))
        .tint(Color(XSS.S.color80))
    }
    func deleteAllFromRealm() {
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
    }
}
