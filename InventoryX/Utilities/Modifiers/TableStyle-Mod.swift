//
//  TableStyle-Mod.swift
//  InventoryX
//
//  Created by Ryan Smetana on 4/7/24.
//

import SwiftUI

struct TableStyleMod: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(Color("Purple050").opacity(0.2))
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(Color.gray.opacity(0.1))
                    .shadow(color: Color.gray.opacity(0.2), radius: 2)
                
            )
            .padding(4)
    }
}
