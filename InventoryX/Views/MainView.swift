//
//  MainView.swift
//  InventoryX
//
//  Created by Smetana, Ryan on 4/24/23.
//

import SwiftUI
import RealmSwift


enum DisplayStates {
    case makeASale, addInventory, inventoryList, salesHistory, inventoryStatus
}

// MARK: - MAIN VIEW MODEL
@MainActor class MainViewModel: ObservableObject {
    @Published var selectedCategoryId: ObjectId!
    @Published var isOnboarding: Bool = false
    @Published var currentDisplay: DisplayStates = .makeASale
    
    init() {
        initializeRealm()
    }
    
    func initializeRealm() {
        let currentVersion: UInt64 = 4
        let config = Realm.Configuration(schemaVersion: currentVersion, migrationBlock: { migration, oldSchemaVersion in
            if (oldSchemaVersion < currentVersion) {
                migration.enumerateObjects(ofType: InventoryItemEntity.className()) { (oldObject, newObject) in }
                migration.enumerateObjects(ofType: SaleEntity.className()) { oldObject, newObject in }
                migration.enumerateObjects(ofType: CategoryEntity.className()) { oldObject, newObject in }
            }
        })
        
        do {
            _ = try Realm(configuration: config)
        } catch {
            print("Error initializing Realm --> \(error.localizedDescription)")
        }
    }
    
    func deleteAllFromRealm() {
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
    }
    
    func setup(categoryId: ObjectId) {
        selectedCategoryId = categoryId
    }
}

// MARK: - MAIN VIEW
struct MainView: View {
    @StateObject var vm: MainViewModel = MainViewModel()
    @ObservedResults(CategoryEntity.self) var categories
//    @ObservedResults(InventoryItemEntity.self) var items
    @State var categoryIndex: Int = 0
        
    var body: some View {
        mainView
            .onAppear {
                if let defaultCategory = categories.first {
//                    currentCategory = defaultCategory
                    vm.setup(categoryId: defaultCategory._id)
                } else {
                    vm.isOnboarding = true
                }
            }
    } //: Body
    
    @ViewBuilder private var mainView: some View {
        if vm.isOnboarding {
            OnboardingView2(isOnboarding: $vm.isOnboarding)
            
        } else {
            NavigationSplitView(columnVisibility: .constant(.detailOnly)) {
                menuView
            } detail: {
                
                switch vm.currentDisplay {
                case .makeASale:
                    
                                        
                    categorySlider
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
            
            
        }
    }
    
    @StateObject var cart = Cart()
    
    let cartWidthPercentage: CGFloat = 0.40
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
    
    var categorySlider: some View {
        ScrollView(.horizontal, showsIndicators: false, content: {
            HStack(spacing: 2) {
                ForEach(categories, id: \.self) { category in
                    Button(action: {
                        vm.selectedCategoryId = category._id
                    }, label: {
                        Text(category.name)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 7)
                            .foregroundColor(.black)
                            .opacity(vm.selectedCategoryId == category._id ? 1.0 : 0.65)
                    })
                    .frame(minWidth: 150)
                    .background(vm.selectedCategoryId == category._id ? Color.white : Color(UIColor.systemGray4))
                    .cornerRadius(15, corners: .bottomLeft)
                    .cornerRadius(15, corners: .bottomRight)
                    
                    Divider().background(Color.black).padding(.vertical, 4)
                }
                
            }
        })
        .background(Color(UIColor.systemGray4).frame(maxWidth: .infinity))
        .frame(maxWidth: .infinity, maxHeight: 40)
    }
    
    
    
    private var menuView: some View {
        VStack {
            Button {
                vm.currentDisplay = .makeASale
            } label: {
                Text("Make A Sale")
            }
            .frame(height: 40)
            
            Divider().padding(.horizontal)
            
            Button {
                vm.currentDisplay = .inventoryList
            } label: {
                Text("Inventory List")
            }
            .frame(height: 40)
            
            Divider().padding(.horizontal)
            
            Button {
                vm.currentDisplay = .inventoryStatus
            } label: {
                Text("Inventory Status")
            }
            .frame(height: 40)
            
            Divider().padding(.horizontal)
            
            Button {
                vm.currentDisplay = .addInventory
            } label: {
                Text("Add Inventory")
            }
            .frame(height: 40)
            
            Divider().padding(.horizontal)
            
            Button {
                vm.deleteAllFromRealm()
            } label: {
                Text("Delete Everything")
            }
            .frame(height: 40)
            
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

class MockRealms {
    static var config: Realm.Configuration {
        MockRealms.previewRealm.configuration
    }
    
    static var previewRealm: Realm = {
        var realm: Realm
        let identifier = "previewRealm"
        let config = Realm.Configuration(inMemoryIdentifier: identifier)
        do {
            realm = try Realm(configuration: config)
            try realm.write {
                realm.add(CategoryEntity.categoryArray)
                realm.add(InventoryItemEntity.itemArray)
            }
            return realm
        } catch let error {
            fatalError("Error: \(error.localizedDescription)")
        }
    }()
}

struct SaleButtonPanel: View {
    @ObservedRealmObject var currentCategory: CategoryEntity
    @State var counter: Int = 0
    
    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            List(currentCategory.items) { item in
                Text(item.name)
            }
            addItemButton
//                        Text("\(categories.first(where: ({ $0._id == currentCategoryId }))!.name)")
//                            .font(.title)
//                            .foregroundColor(primaryColor)
//                            .padding(.bottom, 25)
            
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
//            item.category = vm.selectedCategoryId
            
            item.retailPrice = 1.00
            
            let realm = try! Realm()
            try! realm.write {
                $currentCategory.items.append(item)
//                realm.add(item)
            }
            
            counter += 1
        } label: {
            Text("Add Item")
        }
    } //: Add Item Button
}
