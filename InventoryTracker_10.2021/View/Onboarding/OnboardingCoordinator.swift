//
//  OnboardingCoordinator.swift
//  InventoryTracker_10.2021
//
//  Created by Ryan Smetana on 10/15/21.
//

import SwiftUI

class OnboardingCoordinator: ObservableObject {
    var categoryList: [Category] {
        return categories
    }
    
//    @Published var newCategoryName: String = ""
    @Published var screenIndex: Int = 0
    @Published var isShowingError: Bool = false
    @Published var adminPasscode: String = ""
    
    
    func nextScreen() {
        self.screenIndex += 1
    }
    
    func prevScreen() {
        self.screenIndex -= 1
    }
    
    func createCategory(categoryName: String) {
        
    }
    
    func checkIfCategoryExists(_ categoryName: String) -> Bool {
//        guard categoryList.filter({ return $0.name == categoryName }).isEmpty else {
//            return true
//        }
//        return false
        return categoryList.filter({ return $0.name == categoryName }).isEmpty ? false : true
    }
    
    func deleteCategory() {
        
    }
}
