//
//  XOutlineMod.swift
//  InventoryX
//
//  Created by Ryan Smetana on 11/17/24.
//

import SwiftUI

struct XOutlineMod: ViewModifier {
    let cornerRadius: CGFloat = 7
    let isSelected: Bool
    
    init(isSelected: Bool) {
        self.isSelected = isSelected
    }
    
    func body(content: Content) -> some View {
        content
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(Color.textPrimary, lineWidth: 1.5)
                    .opacity(isSelected ? 1 : 0.2)
            )
            .animation(.snappy, value: isSelected)
    }
}
