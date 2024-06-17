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
            .foregroundStyle(Color("TextColorInverted"))
            .frame(minWidth: 140, idealWidth: 360, maxWidth: 360, minHeight: 36, idealHeight: 48, maxHeight: 54)
            .background(.accent.opacity(0.75))
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .contentShape(RoundedRectangle(cornerRadius: 8))
            .shadow(color: Color("ShadowColor"), radius: 4, x: 0, y: 0)
    }
}




