//
//  GlowingOutline-Mod.swift
//  InventoryX
//
//  Created by Ryan Smetana on 3/25/24.
//

import SwiftUI

struct GlowingOutlineMod: ViewModifier {
    func body(content: Content) -> some View {
        content
            .clipShape(RoundedRectangle(cornerRadius: 6))
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(lineWidth: 0.5)
                    .foregroundStyle(Color("GrayTextColor").opacity(0.4))
                    .shadow(color: Color("bgColor"), radius: 4, x: 3, y: 3)
                    .shadow(color: Color("bgColor"), radius: 4, x: -3, y: -3)
            )
            .clipShape(RoundedRectangle(cornerRadius: 6))
            .shadow(color: Color("ShadowColor"), radius: 4, x: 0, y: 0)
    }
}
