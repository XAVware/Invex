

import SwiftUI
import RealmSwift

enum DisplayStates {
    case makeASale, addInventory, inventoryList, salesHistory, inventoryStatus
}

struct ContentView: View {
    @State var displayState: DisplayStates      = .makeASale
    @StateObject var cart                       = Cart()
    
    @State var isOnboarding: Bool = true
    
    var body: some View {
        if categoryList.count == 0 && self.isOnboarding == true {
            Text("Onboard")
//            OnboardingView(isOnboarding: self.$isOnboarding)
        } else {
            ZStack {
                switch self.displayState {
                case .makeASale:
                    ZStack {
                        MakeASaleView(cart: self.cart)
                        CartView(cart: self.cart)
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
                
                if !self.cart.isConfirmation {
                    MenuView(displayState: self.$displayState)
                }
                
                
            } //: ZStack
            .onChange(of: self.displayState, perform: { value in
                self.cart.resetCart()
            })
            
        }
    }
    
    init() {
        let config = Realm.Configuration(
            schemaVersion: 1,
            
            migrationBlock: { migration, oldSchemaVersion in
                if (oldSchemaVersion < 1) {
                    migration.enumerateObjects(ofType: InventoryItem.className()) { (oldObject, newObject) in
                        
                    }
                    migration.enumerateObjects(ofType: Sale.className()) { oldObject, newObject in
                        
                    }
                    migration.enumerateObjects(ofType: Category.className()) { oldObject, newObject in
                        
                    }
                }
            })
        Realm.Configuration.defaultConfiguration = config
        do {
            _ = try Realm()
        } catch let error as NSError {
            print("Error initializing realm with error-- \(error.localizedDescription)")
        }
        
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(primaryColor)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.black], for: .normal)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        UITableView.appearance().backgroundColor = .clear
        UITableViewCell.appearance().backgroundColor = .clear
        UITableView.appearance().separatorColor = .white
        
//        let realm = try! Realm()
//        try! realm.write({
//            realm.deleteAll()
//        })
        
        
//        let categories = try! Realm().objects(Category.self)
//
//
//        if categoryList.count > 0 {
//            self.isOnboarding.toggle()
//        }
//
//        print(categories.count)
//        print(self.isOnboarding)
    }
}
