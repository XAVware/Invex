//
//  NavigationManager.swift
//  InventoryX
//
//  Created by Ryan Smetana on 6/7/23.
//

import SwiftUI

// 11 Inch iPad (Landscape)
// Width: 1194
// Height: 790

@MainActor class NavigationManager: ObservableObject {
//    @Published var isShowingMenu: Bool = false
//    @Published var isShowingDetail: Bool = false
    @Published var contentWidth: CGFloat!
//    @Published var detailWidth: CGFloat = 0
    @Published var currentDisplay: DisplayStates = .makeASale
    @Published var menuVisibility: NavigationSplitViewVisibility = .detailOnly
    
    @Published var fullWidth: CGFloat = 1100
    
//    var detailWidth: CGFloat {
//        return fullWidth - contentWidth
//    }
    
    var menuWidth: CGFloat {
        return fullWidth == 0 ? 0 : fullWidth
    }
    
    var isMenuHidden: Bool {
        return contentWidth == fullWidth ? true : false
    }
    
    
    func setup(screenWidth: CGFloat) {
        fullWidth = screenWidth
        contentWidth = screenWidth * currentDisplay.detailWidthPercentage
    }
    
    
    func expandDetail(size: DetailSize, animation: Animation? = .easeOut) {
        withAnimation(animation) {
            contentWidth = size.percentVal * fullWidth
        }
    }
    
    func hideDetail(animation: Animation? = .easeOut) {
        withAnimation(animation) {
            contentWidth = 1 * fullWidth
        }
    }
    
    func changeDisplay(to newDisplay: DisplayStates) {
        if newDisplay == .makeASale {
            expandDetail(size: .quarter, animation: nil)
        }
        currentDisplay = newDisplay
        menuVisibility = .detailOnly
    }
    
}
