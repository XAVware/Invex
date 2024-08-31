//
//  LandingHighlight.swift
//  InventoryX
//
//  Created by Ryan Smetana on 8/28/24.
//

import Foundation

struct LandingHighlight: Identifiable, Hashable {
    let id: UUID = UUID()
    let imageName: String
    let title: String
    let caption: String
}
