//
//  RoundedButtonMod.swift
//  InventoryX
//
//  Created by Smetana, Ryan on 4/24/23.
//

import SwiftUI

struct PrimaryButtonMod: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.headline)
            .foregroundStyle(Color.textColorInverted)
            .frame(minWidth: 260, idealWidth: 320, maxWidth: 360, minHeight: 36, idealHeight: 42, maxHeight: 48)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.accent.gradient)
                    .shadow(color: .gray.opacity(0.8), radius: 3, x: 2, y: 2)
            )
            .contentShape(RoundedRectangle(cornerRadius: 8))
    }
}
