//
//  ThemePage-Mod.swift
//  InventoryX
//
//  Created by Ryan Smetana on 11/1/24.
//

import SwiftUI


struct ThemePageMod: ViewModifier {
    @Environment(\.horizontalSizeClass) var hSize
    func body(content: Content) -> some View {
        content
            .padding(hSize == .regular ? 36 : 12)
            .padding()
            .background(.bg)
            .fontDesign(.rounded)
    }
}
