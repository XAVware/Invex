//
//  InventoryXApp.swift
//  InventoryX
//
//  Created by Smetana, Ryan on 4/19/23.
//

import SwiftUI
import RealmSwift

@main
struct InventoryXApp: SwiftUI.App {
    let migrator: RealmMigrator = RealmMigrator()
    
    init() {
        UIColor.classInit
    }
    
    func addSampleData() {
        let drinks = DepartmentEntity(name: "Drinks", restockNum: 12)
        drinks.items.append(objectsIn: ItemEntity.drinkArray)
        drinks.items.append(objectsIn: ItemEntity.foodArray)
        let realm = try! Realm()
        try! realm.write {
            realm.add(drinks)
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ResponsiveView { props in
                RootView(uiProperties: props)
//                NavExperiment(uiProperties: props)
            }
//            .onAppear {
//                addSampleData()
                //                UserDefaults.standard.setValue(true, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
//                                UserDefaults.standard.removeObject(forKey: "passcode")
//                                let realm = try! Realm()
//                                try! realm.write { realm.deleteAll() }
//            }
        }
    } //: Body
}

extension UIColor {
    static let classInit: Void = {
        /// After trial and error, as of 4.18.24 Apple is using UIColor.opaqueSeparator as the color of the divider that appears between NavigationSplitViews.
        let orig = class_getClassMethod(UIColor.self, #selector(getter: opaqueSeparator))
        let new = class_getClassMethod(UIColor.self, #selector(getter: customDividerColor))
        method_exchangeImplementations(orig!, new!)
    }()

    @objc open class var customDividerColor: UIColor {
        return UIColor(Color.clear)
    }
}
