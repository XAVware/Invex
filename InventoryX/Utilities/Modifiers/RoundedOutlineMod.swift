//
//  RoundedOutlineMod.swift
//  InventoryX
//
//  Created by Ryan Smetana on 11/1/24.
//

import SwiftUI

struct RoundedOutlineMod: ViewModifier {
    let cornerRadius: CGFloat
    func body(content: Content) -> some View {
        content
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(Color.gray.opacity(0.25))
            )
    }
}
