//
//  LeadingImageLabelStyle.swift
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
 .labelStyle(LeadingImageLabelStyle())
 
 */

/// Places the label's icon on the left and title on the right.
struct LeadingImageLabelStyle: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.icon
            configuration.title
        }
    }
}

extension LabelStyle where Self == LeadingImageLabelStyle {
    static var leadingImage: LeadingImageLabelStyle { .init() }
}
