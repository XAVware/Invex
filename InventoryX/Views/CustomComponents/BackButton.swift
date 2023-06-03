//
//  BackButton.swift
//  InventoryX
//
//  Created by Ryan Smetana on 6/2/23.
//

import SwiftUI

struct BackButton: View {
    @Environment(\.dismiss) var dismiss
    let buttonWidth: CGFloat = 18
    
    var body: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "xmark")
                .resizable()
                .scaledToFit()
                .frame(width: buttonWidth)
                .foregroundColor(.black)
        }
        .padding()
    } //: Body
}

struct BackButton_Previews: PreviewProvider {
    static var previews: some View {
        BackButton()
    }
}
