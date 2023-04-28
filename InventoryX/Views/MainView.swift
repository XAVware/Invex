//
//  MainView.swift
//  InventoryX
//
//  Created by Smetana, Ryan on 4/24/23.
//

import SwiftUI
import RealmSwift

@MainActor class MainViewModel: ObservableObject {
    @Published var selectedCategory: CategoryEntity!
    @Published var currentDisplay: DisplayStates = .makeASale
    
    func deleteAllFromRealm() {
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
    }
    
    func setup(category: CategoryEntity) {
        selectedCategory = category
    }
}




// MARK: - MAIN VIEW

struct MainView: View {
    @EnvironmentObject var userManager: UserManager
    @StateObject var vm: MainViewModel = MainViewModel()
    @ObservedResults(CategoryEntity.self) var categories
    
    @StateObject var cart = Cart()
    let cartWidthPercentage: CGFloat = 0.40
    
    var body: some View {
        mainView
    } //: Body
    
    private var mainView: some View {
        NavigationSplitView(columnVisibility: .constant(.detailOnly)) {
            menuView
        } detail: {
            switch vm.currentDisplay {
            case .makeASale:
                VStack(spacing: 0) {
                    List(categories) { category in
                        Text(category.name)
                            .modifier(TextMod(.body, vm.selectedCategory == category ? .bold : .regular))
                        ForEach(category.items) { item in
                            Text(item.name)
                        }
                    }
                    
                    //Move onboarding logic to @main
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 2) {
                            ForEach(categories) { category in
                                Button {
                                    vm.selectedCategory = category
                                } label: {
                                    Text(category.name)
                                        .padding(10)
                                        .opacity(vm.selectedCategory == category ? 1.0 : 0.65)
                                }
                                .frame(minWidth: 150)
                                .background(vm.selectedCategory == category ? Color.white : Color(UIColor.systemGray4))
                                .cornerRadius(15, corners: [.bottomLeft, .bottomRight])
                                
                                Divider()
                                    .background(Color.black)
                                    .padding(.vertical, 4)
                            }
                            
                        } //: HStack
                    } //: Scroll
                    .frame(maxWidth: .infinity, maxHeight: 40)
                    .background(Color(UIColor.systemGray4).frame(maxWidth: .infinity))
                } //: VStack
                
            case .addInventory:
                AddInventoryView()
            case .inventoryList:
                InventoryListView()
            case .salesHistory:
                SalesHistoryView()
            case .inventoryStatus:
                InventoryStatusView()
            }
            
        } //: Navigation Stack
        .navigationSplitViewStyle(.prominentDetail)
        .onAppear {
            guard let defaultCategory = categories.first else { return }
            vm.setup(category: defaultCategory)
        }
    }
    
    
//    private var makeASaleView: some View {
//        GeometryReader { geometry in
//            HStack(spacing: 0) {
//                if !self.cart.isConfirmation && categoryList.count > 0 {
//                    VStack(alignment: .center, spacing: 5) {
//                        Text("\(categories.first(where: ({ $0._id == vm.selectedCategoryId }))!.name)")
//                            .font(.title)
//                            .foregroundColor(primaryColor)
//                            .padding(.bottom, 25)
//
//                        ScrollView {
//                            LazyVGrid(columns: [GridItem(.adaptive(minimum: 140))], spacing: 0) {
//                                ForEach(items) { item in
//
//                                    Button(action: {
//                                        cart.addItem(item)
//                                    }) {
//                                        VStack(spacing: 0) {
//                                            Text(item.name)
//                                                .font(.system(size: 18, weight: .semibold, design:.rounded))
//
//                                            if (item.subtype != "") {
//                                                Text(item.subtype)
//                                                    .font(.system(size: 14, weight: .light, design:.rounded))
//                                            }
//                                        }
//                                        .foregroundColor(.black)
//                                        .frame(width: 140, height: 80)
//                                        .background(.blue)
//                                    }
//                                    .cornerRadius(9)
//                                    .padding()
//                                    .shadow(radius: 8)
//
//                                } //: ForEach
//                            } //: LazyVGrid
//                            .padding(.horizontal, 10)
//                        } //: ScrollView
//                        categorySlider
//                    } //: VStack
//                    .frame(width: geometry.size.width - (geometry.size.width * cartWidthPercentage))
//                    Spacer().frame(width: geometry.size.width * cartWidthPercentage)
//                }
//            } //: HStack
//        }
//    } //: Make A Sale View
    
//    var categorySlider: some View {
//        ScrollView(.horizontal, showsIndicators: false) {
//            HStack(spacing: 2) {
//                ForEach(categories) { category in
//                    Button {
//                        vm.selectedCategory = category
//                    } label: {
//                        Text(category.name)
//                            .padding(.vertical, 10)
//                            .padding(.horizontal, 7)
//                            .opacity(vm.selectedCategory == category ? 1.0 : 0.65)
//                    }
//                    .frame(minWidth: 150)
//                    .background(vm.selectedCategory == category ? Color.white : Color(UIColor.systemGray4))
//                    .cornerRadius(15, corners: [.bottomLeft, .bottomRight])
//
//                    Divider().background(Color.black).padding(.vertical, 4)
//                }
//
//            } //: HStack
//        }
//        .background(Color(UIColor.systemGray4).frame(maxWidth: .infinity))
//        .frame(maxWidth: .infinity, maxHeight: 40)
//    }
    
    
    
    private var menuView: some View {
        VStack {
            ForEach(DisplayStates.allCases, id: \.self) { displayState in
                Button {
                    vm.currentDisplay = displayState
                } label: {
                    Text("\(displayState.menuButtonText)")
                }
                .frame(height: 40)
                
                Divider().padding(.horizontal)
            }
            
            Button {
                vm.deleteAllFromRealm()
            } label: {
                Text("Delete Everything")
            }
            .frame(height: 40)
//            Button {
//                vm.currentDisplay = .makeASale
//            } label: {
//                Text("Make A Sale")
//            }
//            .frame(height: 40)
//            
//            Divider().padding(.horizontal)
//            
//            Button {
//                vm.currentDisplay = .inventoryList
//            } label: {
//                Text("Inventory List")
//            }
//            .frame(height: 40)
//            
//            Divider().padding(.horizontal)
//            
//            Button {
//                vm.currentDisplay = .inventoryStatus
//            } label: {
//                Text("Inventory Status")
//            }
//            .frame(height: 40)
//            
//            Divider().padding(.horizontal)
//            
//            Button {
//                vm.currentDisplay = .addInventory
//            } label: {
//                Text("Add Inventory")
//            }
//            .frame(height: 40)
//            
//            Divider().padding(.horizontal)
//            
//            Button {
//                vm.deleteAllFromRealm()
//            } label: {
//                Text("Delete Everything")
//            }
//            .frame(height: 40)
            
            Spacer()
        } //: VStack
    } //: Menu View
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .modifier(PreviewMod())
    }
}



struct SaleButtonPanel: View {
    @ObservedRealmObject var currentCategory: CategoryEntity
    @State var counter: Int = 0
    
    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            Text("\(currentCategory.name)")
                .font(.title)
                .foregroundColor(primaryColor)
                .padding(.bottom, 25)
            
            addItemButton
//                        ScrollView {
//                            LazyVGrid(columns: [GridItem(.adaptive(minimum: 140))], spacing: 0) {
//                                ForEach(items.filter({ $0.category == vm.selectedCategoryId })) { item in
//                                    Button(action: {
//                                        cart.addItem(item)
//                                    }) {
//                                        VStack(spacing: 0) {
//                                            Text(item.name)
//                                                .font(.system(size: 18, weight: .semibold, design:.rounded))
//
//                                            if (item.subtype != "") {
//                                                Text(item.subtype)
//                                                    .font(.system(size: 14, weight: .light, design:.rounded))
//                                            }
//                                        }
//                                        .foregroundColor(.black)
//                                        .frame(width: 140, height: 80)
//                                        .background(.blue)
//                                    }
//                                    .cornerRadius(9)
//                                    .padding()
//                                    .shadow(radius: 8)
//                                } //: ForEach
//                            } //: LazyVGrid
//                        } //: ScrollView
        } //: VStack
    } //: Body
    
    private var addItemButton: some View {
        Button {
            let item = InventoryItemEntity()
            item.name = "Item \(counter)"
            item.retailPrice = 1.00
            
            let realm = try! Realm()
            try! realm.write {
                $currentCategory.items.append(item)
//                realm.add(item)
            }
            
            counter += 1
            
            print("Item Added:")
            print(item)
        } label: {
            Text("Add Item")
        }
    } //: Add Item Button
}
