//
//  Title-Mod.swift
//  InventoryX
//
//  Created by Ryan Smetana on 3/25/24.
//

import SwiftUI

struct TitleMod: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .fontWeight(.bold)
            .fontDesign(.rounded)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}
