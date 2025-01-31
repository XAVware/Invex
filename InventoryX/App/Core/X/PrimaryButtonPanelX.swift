//
//  PrimaryButtonPanelX.swift
//  InventoryX
//
//  Created by Ryan Smetana on 11/17/24.
//

import SwiftUI

struct PrimaryButtonPanelX: View {
    let onCancel: () -> Void
    let onSave: () -> Void
    var body: some View {
        HStack {
            Button("Cancel", action: onCancel)
                .buttonStyle(.borderless)
                .padding(12)
            Spacer()
            Button("Save", action: onSave)
                .font(.headline)
                .buttonStyle(.borderedProminent)
        } //: HStack
        .buttonBorderShape(.roundedRectangle)
        .controlSize(.large)
        .frame(maxWidth: .infinity, maxHeight: 54)
    }
}
