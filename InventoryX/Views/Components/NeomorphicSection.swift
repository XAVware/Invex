//
//  NeomorphicSection.swift
//  InventoryX
//
//  Created by Ryan Smetana on 9/1/24.
//

import SwiftUI

struct NeomorphicSection<C: View>: View {
    let content: C
    let headerText: String
    
    init(header: String, @ViewBuilder content: (() -> C)) {
        self.content = content()
        self.headerText = header
    }
    
    var body: some View {
        Section {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(
                        .shadow(.inner(color: .neoUnderDark, radius: 3, x: 1, y: 1))
                        .shadow(.inner(color: .neoUnderLight, radius: 2, x: -3, y: -2))
                    )
                    .foregroundColor(.neoUnderBg)
                
                content
                    .padding(.vertical, 6)
            }
        } header: {
            Text(headerText)
                .padding(.horizontal, 10)
//                .padding(.vertical, -8)
                .frame(maxWidth: .infinity, alignment: .leading)
                .fontWeight(.light)
                .foregroundStyle(Color.textSecondary)
        }
    }
    
}
