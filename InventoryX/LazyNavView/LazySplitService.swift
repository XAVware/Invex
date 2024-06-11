//
//  LazySplitService.swift
//  InventoryX
//
//  Created by Ryan Smetana on 6/11/24.
//

import SwiftUI

// Maybe move towards:
//enum LazySplitColumn { case leftSidebar, supplemental, primaryContent, detail, rightSidebar }

@MainActor class LazyNavService {
    @Published var mainDisplay: DisplayState
    @Published var path: NavigationPath = .init()
    @Published var detailPath: NavigationPath = .init()
    
    static let shared = LazyNavService()
    
    init() {
        self.mainDisplay = DisplayState.allCases.first ?? .settings
    }
    
    func changeDisplay(to newDisplay: DisplayState) {
        // Clear paths before changing display?
        detailPath = .init()
        path = .init()
        mainDisplay = newDisplay
    }
    
    func pushView(_ display: DetailPath, isDetail: Bool) {
        if isDetail {
            detailPath.append(display)
        } else {
            path.append(display)
        }
    }
    
    func popView(fromDetail: Bool) {
        if fromDetail {
            detailPath.removeLast()
        } else {
            
            path.removeLast()
        }
    }
}
