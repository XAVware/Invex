//
//  OnboardingCoordinator.swift
//  InventoryTracker_10.2021
//
//  Created by Ryan Smetana on 10/15/21.
//

import SwiftUI

class OnboardingCoordinator: ObservableObject {
    
    @Published var categoryList: [Category] = []
    
    @Published var screenIndex: Int = 0
    @Published var isShowingError: Bool = false
    @Published var adminPasscode: String = ""
    
    init() {
        categoryList = categories
    }
    
    
    func nextScreen() {
        self.screenIndex += 1
    }
    
    func prevScreen() {
        self.screenIndex -= 1
    }
    
    func createCategory(categoryName: String) {
        let newCategory: Category = Category(name: categoryName, restockThresh: 0)
        categories.append(newCategory)
        updateCategoryList()
    }
    
    func checkIfCategoryExists(_ categoryName: String) -> Bool {
        return categoryList.filter({ return $0.name == categoryName }).isEmpty ? false : true
    }
    
    func deleteCategory(_ categoryName: String) {
        categories.removeAll(where: { $0.name == categoryName} )
        updateCategoryList()
    }
    
    func updateCategoryList() {
        categoryList = categories
    }
    
    func changeRestockPoint(for categoryName: String, value: Int) {
        let tempCategory = categoryList.filter({ return $0.name == categoryName })[0]
        
        if value < 0 {  guard tempCategory.restockThresh > 0 else { return } }
        
        if let tempCategoryIndex = categories.firstIndex(where: { $0.id == tempCategory.id }) {
            let newCategory = Category(id: tempCategory.id, name: tempCategory.name, restockThresh: tempCategory.restockThresh + value)
            deleteCategory(tempCategory.name)
            categories.insert(newCategory, at: tempCategoryIndex)
        }
        updateCategoryList()
    }
}
