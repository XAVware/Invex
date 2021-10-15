//
//  OnboardingCoordinator.swift
//  InventoryTracker_10.2021
//
//  Created by Ryan Smetana on 10/15/21.
//

import Foundation

class OnboardingCoordinator: ObservableObject {
    var categoryList: [Category] = []
    
    
    
    init() {
        categoryList = categories
    }
}
