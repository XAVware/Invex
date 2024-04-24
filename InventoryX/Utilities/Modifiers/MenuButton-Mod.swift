//
//  MenuButton-Mod.swift
//  InventoryX
//
//  Created by Ryan Smetana on 4/9/24.
//

import SwiftUI

struct MenuButtonMod: ViewModifier {
    let isSelected: Bool
    func body(content: Content) -> some View {
        content
            .font(.title3)
            .fontDesign(.rounded)
            .padding(.leading)
            .padding(.vertical, 8)
            .frame(maxHeight: 64)
//            .foregroundStyle(isSelected ? .white : Color("bgColor").opacity(0.6))
            .foregroundStyle(Color("lightAccent").opacity(isSelected ? 1.0 : 0.6))
    }
}
