//
//  TabButtonModel.swift
//  InventoryX
//
//  Created by Ryan Smetana on 1/31/25.
//

import Foundation

struct TabButtonModel: Identifiable {
    let id: UUID =  UUID()
    let destination: LSXDisplay
    let unselectedIconName: String
    let selectedIconName: String
    let title: String
}
