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
            .foregroundStyle(.accent)
            .opacity(isSelected ? 1.0 : 0.9)
            .padding(.horizontal)
            .padding(.vertical, 8)
            .overlay(isSelected ? Rectangle().fill(.accent).frame(height: 3) : nil, alignment: .bottom)
    }
}



