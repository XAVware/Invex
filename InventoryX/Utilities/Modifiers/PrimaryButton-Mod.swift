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
            .font(.title3)
            .fontWeight(.semibold)
            .foregroundStyle(.white)
            .frame(maxWidth: 420, maxHeight: 54)
            .background(.ultraThinMaterial)
            .background(Theme.primaryColor)
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}




