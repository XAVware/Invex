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
            .foregroundStyle(.white)
            .frame(minWidth: 140, idealWidth: 420, maxWidth: .infinity, minHeight: 36, idealHeight: 48, maxHeight: 54)
            .background(.ultraThinMaterial)
            .background(Theme.primaryColor)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .shadow(color: Color.gray.opacity(0.20), radius: 4, x: 0, y: 0)
    }
}




