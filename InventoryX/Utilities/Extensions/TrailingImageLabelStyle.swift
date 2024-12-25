//
//  TrailingImageLabelStyle.swift
//  InventoryX
//
//  Created by Ryan Smetana on 12/24/24.
//

import SwiftUI

/*
 Usage:
 
 Button("Title", systemImage: "star") {
     foo
 }
 .labelStyle(TrailingImageLabelStyle())
 
 */

/// Places the label's icon on the right and title on the left.
struct TrailingImageLabelStyle: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.title
            configuration.icon
        }
    }
}

extension LabelStyle where Self == TrailingImageLabelStyle {
    static var trailingImage: TrailingImageLabelStyle { .init() }
}
