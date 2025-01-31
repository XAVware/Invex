//
//  NavigationService.swift
//  InventoryX
//
//  Created by Ryan Smetana on 1/31/25.
//

import SwiftUI

@Observable
class NavigationService {
    var path: NavigationPath = .init()
    var sidebarVis: SidebarState?
    var sidebarWidth: CGFloat?
    /// Toggle between hidden and sidebar cart state. Only called from regular horizontal size class devices.
    func toggleSidebar() {
        withAnimation {
            if sidebarVis == .hidden {
                sidebarVis = .showing
            } else {
                sidebarVis = .hidden
            }
        }
    }
}
