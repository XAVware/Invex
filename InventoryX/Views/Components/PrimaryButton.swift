//
//  PrimaryButton.swift
//  InventoryX
//
//  Created by Ryan Smetana on 8/29/24.
//

import SwiftUI

struct PrimaryButton: View {
    @State var label: String
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            Spacer()
            Text(label)
            Spacer()
        }
        .modifier(PrimaryButtonMod())
    }
}

#Preview {
    PrimaryButton(label: "Hello") {}
}
