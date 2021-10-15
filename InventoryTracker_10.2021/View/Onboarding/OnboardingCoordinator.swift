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
        var result = categoryList.filter({ return $0.name == categoryName })
        guard result.isEmpty else {
            return
        }
        print(result)
    }
    
    func deleteCategory() {
        
    }
}
