//
//  InputFieldLabel.swift
//  InventoryX
//
//  Created by Ryan Smetana on 3/22/24.
//

import SwiftUI

struct InputFieldLabel: View {
    let title: String
    let subtitle: String?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .modifier(FieldTitleMod())
                .frame(maxWidth: .infinity, alignment: .leading)
            if let sub = subtitle {
                Text(sub)
                    .modifier(FieldSubtitleMod())
                    .frame(maxWidth: .infinity, alignment: .leading)
                
            }
        } //: VStack
    }
}
