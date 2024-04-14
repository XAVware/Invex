//
//  TableStyle-Mod.swift
//  InventoryX
//
//  Created by Ryan Smetana on 4/7/24.
//

import SwiftUI

struct TableStyleMod: ViewModifier {
    let sizeClass: UserInterfaceSizeClass?
    
    init(sizeClass: UserInterfaceSizeClass? = .regular) {
        self.sizeClass = sizeClass
    }
    
    func body(content: Content) -> some View {
        content
            .background(Color("Purple050").opacity(0.2))
            .overlay(
                sizeClass == .regular ?
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color.gray.opacity(0.1))
                        .shadow(color: Color.gray.opacity(0.2), radius: 2)
                : nil
            )
//            .padding(4)
    }
}
