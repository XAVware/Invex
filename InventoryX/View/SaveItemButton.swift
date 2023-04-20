//
//  SaveItemButton.swift
//  InventoryApp
//
//  Created by Ryan Smetana on 12/13/20.
//

import SwiftUI

struct SaveItemButton: View {
    @State var action: () -> Void
    
    private let backgroundColor = Color("GreenBackground")
    
    var body: some View {
        Button(action: { self.action() }) {
            Text("Save")
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundColor(.white)
        }
        .padding()
        .frame(width: 400, height: 60)
        .background(self.backgroundColor)
        .cornerRadius(30)
        .shadow(color: Color("ShadowColor"), radius: 8, x: 0, y: 4)
    }
}
