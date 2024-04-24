//
//  SecondaryButton-Mod.swift
//  InventoryX
//
//  Created by Ryan Smetana on 3/26/24.
//

import SwiftUI

struct SecondaryButtonMod: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.callout)
            .foregroundStyle(Color("TextColorInverted"))
            .frame(minWidth: 64,
                   idealWidth: 72,
                   maxWidth: 84,
                   minHeight: 28,
                   idealHeight: 32,
                   maxHeight: 36)
            .background(.ultraThinMaterial)
            .background(.accent)
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
