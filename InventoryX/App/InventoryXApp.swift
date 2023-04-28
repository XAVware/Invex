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
    let migrator: RealmMigrator = RealmMigrator(currentSchemaVersion: 4)
    @ObservedResults(CategoryEntity.self) var categories
    @ObservedResults(UserEntity.self) var users
    @StateObject var userManager: UserManager = UserManager()
    
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
//            switch true {
//            case users.count > 0:
//                mainView
//            case categories.count == 0 && users.count == 0:
//                onboardingView
//            case userManager.isLoggedIn == false:
//                onboardingView
//            default:
//                Text("Isssue with combinations")
//                    .modifier(TextMod(.title, .bold))
//            }
            
//            if categories.count == 0 && users.count == 0 {
            if userManager.currentUser == nil {
                onboardingView
                    .onChange(of: users) { newValue in
                        print("users changed to \(newValue)")
                    }
            } else {
                mainView
            }
            
            
//            if userManager.isLoggedIn == false {
//                onboardingView
//            } else if categories.count == 0 {
//                onboardingView
//            } else {
//                mainView
//            }
        }
    } //: Body
    
    private var onboardingView: some View {
        OnboardingView()
            .environmentObject(userManager)
    }
    
    private var mainView: some View {
        MainView()
            .environmentObject(userManager)
            .onAppear {
                print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.path)
                UserDefaults.standard.setValue(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
            }
    }
}
