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
    @Published var contentWidth: CGFloat
//    @Published var detailWidth: CGFloat = 0
    @Published var currentDisplay: DisplayStates = .inventoryList
    @Published var menuVisibility: NavigationSplitViewVisibility = .detailOnly
    
    @Published var fullWidth: CGFloat
    @Published var detailSize: DetailSize = .hidden
    
    @Published var selectedItem: InventoryItemEntity?
    
    init() {
        contentWidth = UIScreen.main.bounds.width
        fullWidth = UIScreen.main.bounds.width
    }
    
    var detailWidth: CGFloat {
        return fullWidth - contentWidth
    }
    
    var menuWidth: CGFloat {
        return fullWidth == 0 ? 0 : 0.2 * fullWidth
    }
    
    func toggleCartPreview() {
        if detailSize == .hidden {
            expandDetail(size: .quarter)
        } else {
            expandDetail(size: .hidden)
        }
    }
    
    func toggleMenu() {
        if menuVisibility == .detailOnly {
            menuVisibility = .all
            if detailSize != .hidden {
                hideDetail(animation: .easeOut)
            }
        } else {
            menuVisibility = .detailOnly
        }
    }
    
    func expandDetail(size: DetailSize, animation: Animation? = .easeOut) {
        detailSize = size
        withAnimation(animation) {
            contentWidth = size.percentVal * fullWidth
        }
    }
    
    func hideDetail(animation: Animation? = .easeOut) {
        detailSize = .hidden
        withAnimation(animation) {
            contentWidth = 1 * fullWidth
        }
    }
    
    func changeDisplay(to newDisplay: DisplayStates) {
        if newDisplay == .makeASale {
            expandDetail(size: .quarter, animation: nil)
        } else if newDisplay == .inventoryList {
            hideDetail(animation: nil)
        } else {
            hideDetail(animation: nil)
        }
        currentDisplay = newDisplay
        menuVisibility = .detailOnly
    }
    
    func inventoryListItemSelected(item: InventoryItemEntity?) {
        selectedItem = item
        expandDetail(size: .third)
    }
    
}
