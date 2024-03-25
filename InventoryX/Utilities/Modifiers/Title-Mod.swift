//
//  Title-Mod.swift
//  InventoryX
//
//  Created by Ryan Smetana on 3/25/24.
//

import SwiftUI

struct FieldTitleMod: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.headline)
            .fontWeight(.regular)
            .fontDesign(.rounded)
            .foregroundStyle(.black)
    }
}

struct FieldSubtitleMod: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.subheadline)
            .fontDesign(.rounded)
            .foregroundStyle(.gray)
    }
}

