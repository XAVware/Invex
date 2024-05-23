//
//  SidebarToggle.swift
//  InventoryX
//
//  Created by Ryan Smetana on 5/22/24.
//

import SwiftUI

struct SidebarToggle: ToolbarContent {
    @EnvironmentObject var vm: LazyNavViewModel
    @ToolbarContentBuilder var body: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Button("Menu", systemImage: "sidebar.leading") {
                print("Tap")
                print("Original pref col: \(vm.prefCol)")
                print("Original col vis: \(vm.colVis)")


                withAnimation {
                    vm.toggleSidebar()
                }
                print("New pref col: \(vm.prefCol)")
                print("New col vis: \(vm.colVis)")
            }
        }
    }
}

