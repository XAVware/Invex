//
//  MainView.swift
//  InventoryX
//
//  Created by Smetana, Ryan on 4/24/23.
//

import SwiftUI
import RealmSwift

// MARK: - MAIN VIEW MODEL
@MainActor class MainViewModel: ObservableObject {
    @Published var selectedCategoryId: ObjectId!
    @Published var isOnboarding: Bool = false
    
    init() {
        initializeRealm()
    }
    
    func initializeRealm() {
        let currentVersion: UInt64 = 2
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
    
    var body: some View {
        mainView
            .onAppear {
                guard let defaultCategory = categories.first else {
                    vm.isOnboarding = true
                    return
                }
                
                vm.setup(categoryId: defaultCategory._id)
            }
    } //: Body
    
    @ViewBuilder private var mainView: some View {
        if vm.isOnboarding {
            OnboardingView2(isOnboarding: $vm.isOnboarding)
        } else {
            NavigationSplitView(columnVisibility: .constant(.doubleColumn)) {
                menuView
            } detail: {
                List() {
                    ForEach(categories) { category in
                        Text(category.name)
                            .fontWeight(vm.selectedCategoryId == category._id ? .bold : .regular)
                    }
                }
                
            } //: Navigation Stack
            .navigationSplitViewStyle(.prominentDetail)
            
        }
    }
    
    @StateObject var cart = Cart()
    private var makeASaleView: some View {
        MakeASaleView(cart: cart)
    } //: Make A Sale View
    
    private var menuView: some View {
        VStack {
            Button {
            
            } label: {
                Text("Make A Sale")
            }
            .frame(height: 40)
            
            Divider().padding(.horizontal)
            
            Button {
                //
            } label: {
                Text("Inventory List")
            }
            .frame(height: 40)
            
            Divider().padding(.horizontal)
            
            Button {
                //
            } label: {
                Text("Inventory Status")
            }
            .frame(height: 40)
            
            Divider().padding(.horizontal)
            
            Button {
                //
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
    }
}


struct MakeASaleView: View {
//    @ObservedSectionedResults(Dog.self, sectionKeyPath: \.firstLetter) var dogs
    
    @ObservedObject var cart: Cart
    @State var selectedTypeID: Int = 0
    
    let cartWidthPercentage: CGFloat = 0.40
    
//    var results: Results<Item> {
//        let predicate = NSPredicate(format: "itemType == %@", concessionTypes[selectedTypeID].type)
//        return try! Realm().objects(Item.self).filter(predicate).sorted(byKeyPath: "name", ascending: true)
//    }
    
    
    var results: Results<InventoryItem> {
        let predicate = NSPredicate(format: "itemType == %@", categoryList[selectedTypeID].name)
        return try! Realm().objects(InventoryItem.self).filter(predicate).sorted(byKeyPath: "name", ascending: true)
    }
    
    
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                if !self.cart.isConfirmation && categoryList.count > 0 {
                    VStack(alignment: .center, spacing: 5) {
                        Text("\(categoryList[self.selectedTypeID].name)")
                            .font(.title)
                            .foregroundColor(primaryColor)
                            .padding(.bottom, 25)
//                        TypePickerView(typeID: self.$selectedTypeID)
                        ScrollView {
                            LazyVGrid(columns: [GridItem(.adaptive(minimum: 140))], spacing: 0) {
                                ForEach(self.getItems(), id: \.self) { item in
                                    
                                    Button(action: {
                                        cart.addItem(item)
                                    }) {
                                        VStack(spacing: 0) {
                                            Text(item.name)
                                                .font(.system(size: 18, weight: .semibold, design:.rounded))

                                            if (item.subtype != "") {
                                                Text(item.subtype)
                                                    .font(.system(size: 14, weight: .light, design:.rounded))
                                            }
                                        }
                                        .foregroundColor(.black)
                                        .frame(width: 140, height: 80)
                                        .background(.blue)
                                    }
                                    .cornerRadius(9)
                                    .padding()
                                    .shadow(radius: 8)
                                    
                                }
                            }
                            .padding(.horizontal, 10)
                        } //: ScrollView
                        CategorySlider(categoryIndex: self.$selectedTypeID)
                    } //: VStack
                    .frame(width: geometry.size.width - (geometry.size.width * cartWidthPercentage))
                    Spacer().frame(width: geometry.size.width * cartWidthPercentage)
                }
            } //: HStack
        }
        
    } //: VStack
    
    func getItems() -> [InventoryItem] {
        var tempList: [InventoryItem] = []
        for item in results {
            tempList.append(item)
        }
        return tempList
    }
}


//struct ItemButton: View {
//    @ObservedObject var cart: Cart
//    var item: InventoryItem
//
//    var backgroundColor: Color {
//        switch item.itemType {
//        case categoryList[0].name:
//            return .blue
//        case categoryList[1].name:
//            return .green
//        case categoryList[2].name:
//            return .yellow
//        default:
//            return .white
//        }
//    }
//
//    var body: some View {
//        Button(action: {
//            self.cart.addItem(self.item)
//        }) {
//            VStack(spacing: 0) {
//                Text(item.name)
//                    .font(.system(size: 18, weight: .semibold, design:.rounded))
//
//                if (item.subtype != "") {
//                    Text(item.subtype)
//                        .font(.system(size: 14, weight: .light, design:.rounded))
//                }
//            }
//            .foregroundColor(.black)
//            .frame(width: 140, height: 80)
//            .background(backgroundColor)
//        }
//        .cornerRadius(9)
//        .padding()
//    }
//}
