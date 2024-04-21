//
//  PaneOutline-Mod.swift
//  InventoryX
//
//  Created by Ryan Smetana on 4/19/24.
//

import SwiftUI

struct PaneOutlineMod: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.horizontal)
            .padding(.vertical, 8)
            .clipShape(RoundedRectangle(cornerRadius: 6))
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(.gray.opacity(0.7), lineWidth: 0.5)
            )
            .background(.white)
    }
}
