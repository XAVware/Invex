//
//  InventoryXApp.swift
//  InventoryX
//
//  Created by Smetana, Ryan on 4/19/23.
//

import SwiftUI

@main
struct InventoryXApp: App {
    let migrator: RealmMigrator = RealmMigrator(currentSchemaVersion: 4)
    
    init() {
//        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(primaryColor)
//        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.black], for: .normal)
//        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
//        UITableView.appearance().backgroundColor = .clear
//        UITableViewCell.appearance().backgroundColor = .clear
//        UITableView.appearance().separatorColor = .white
        
        
    }

    var body: some Scene {
        WindowGroup {
            MainView()
                .onAppear {
                    print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.path)
                    UserDefaults.standard.setValue(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
                }
        }
    }
    

}
