//
//  ItemGridButton-Mod.swift
//  InventoryX
//
//  Created by Ryan Smetana on 3/25/24.
//

import SwiftUI

struct ItemGridButtonMod: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(.ultraThinMaterial)
            .background(Color("Purple050"))
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .shadow(color: Color("Purple900").opacity(0.15), radius: 3, x: 2, y: 2)
            .shadow(color: Color("Purple200").opacity(0.15), radius: 3, x: -2, y: -2)
    }
}
