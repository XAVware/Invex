//
//  RoundedOutlineMod.swift
//  InventoryX
//
//  Created by Ryan Smetana on 11/1/24.
//

import SwiftUI

struct RoundedOutlineMod: ViewModifier {
    let cornerRadius: CGFloat
    let borderColor: Color
    let lineWidth: CGFloat
    
    init(cornerRadius: CGFloat, borderColor: Color = Color.bg000, lineWidth: CGFloat = 1) {
        self.cornerRadius = cornerRadius
        self.borderColor = borderColor
        self.lineWidth = lineWidth
    }
    
    func body(content: Content) -> some View {
        content
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(borderColor.opacity(0.6))
            )
    }
}
