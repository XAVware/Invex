//
//  DepartmentButtonMod.swift
//  InventoryX
//
//  Created by Ryan Smetana on 3/17/24.
//

import SwiftUI

struct DepartmentButtonMod: ViewModifier {
    let isSelected: Bool
    func body(content: Content) -> some View {
        content
            .font(.headline)
            .fontWeight(isSelected ? .semibold : .regular)
            .foregroundStyle(Color("Purple900"))
            .opacity(isSelected ? 1.0 : 0.9)
            .padding(.horizontal)
            .padding(.vertical, 8)
            .overlay(isSelected ? Rectangle().fill(Color("Purple900")).frame(height: 3) : nil, alignment: .bottom)
    }
}


struct ItemGridButtonMod: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(.ultraThinMaterial)
            .background(Color("Purple050"))
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .shadow(color: Color("Purple900").opacity(0.15), radius: 3, x: 2, y: 2)
            .shadow(color: Color("Purple200").opacity(0.15), radius: 3, x: -2, y: -2)
    }
}
