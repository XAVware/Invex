//
//  MainView.swift
//  InventoryX
//
//  Created by Smetana, Ryan on 4/24/23.
//

import SwiftUI
import RealmSwift

@MainActor class MainViewModel: ObservableObject {
    @ObservedResults(CategoryEntity.self) var categories
    @Published var selectedCategoryId: ObjectId!
    @Published var isOnboarding: Bool = false
    
    init() {
        initializeRealm()
    }
    
    func initializeRealm() {
        let config = Realm.Configuration(schemaVersion: 1, migrationBlock: { migration, oldSchemaVersion in
            if (oldSchemaVersion < 1) {
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

struct MainView: View {
    @StateObject var vm: MainViewModel = MainViewModel()
    @ObservedResults(CategoryEntity.self) var categories
    
    var body: some View {
        mainView
            .onAppear {
                guard let defaultCategory = categories.first else {
                    print("No Categories -- Starting Onboarding Process")
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
                    ForEach(vm.categories) { category in
                        Text(category.name)
                            .fontWeight(vm.selectedCategoryId == category._id ? .bold : .regular)
                    }
                }
                
            } //: Navigation Stack
            .navigationSplitViewStyle(.prominentDetail)
        }
    }
    
    private var makeASaleView: some View {
        Text("Make A Sale")
    } //: Make A Sale View
    
    private var menuView: some View {
        VStack {
            Button {
                let tempCategory = CategoryEntity(name: "Test")
                vm.$categories.append(tempCategory)
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
