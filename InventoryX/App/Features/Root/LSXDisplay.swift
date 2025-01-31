//
//  DisplayState.swift
//  GenericSplitView
//
//  Created by Ryan Smetana on 5/9/24.
//

import SwiftUI

enum LSXDisplay: Hashable, CaseIterable {
    // Main displays
    static var allCases: [LSXDisplay] { [.pos, .inventoryList, .settings] }
    
    case pos
    case inventoryList
    case settings
    
    case company
    case department(DepartmentEntity)
    case item(ItemEntity)
    case confirmSale
}
