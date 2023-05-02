//
//  AddItemButton.swift
//  InventoryX
//
//  Created by Smetana, Ryan on 5/2/23.
//

import SwiftUI

struct AddItemButton: View {
    @State var isShowingAddItem: Bool = false
    
    func addItemTapped() {
        isShowingAddItem = true
    }
    
    var body: some View {
        Button {
            addItemTapped()
        } label: {
            Text("New Item")
                .modifier(TextMod(.footnote, .semibold, darkTextColor))
            
            Image(systemName: "plus")
                .scaledToFit()
                .foregroundColor(darkTextColor)
                .bold()
        }
        .padding(8)
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(darkTextColor, lineWidth: 3))
        .fullScreenCover(isPresented: $isShowingAddItem) {
            AddItemView()
        }
    }
}

struct AddItemButton_Previews: PreviewProvider {
    static var previews: some View {
        AddItemButton()
    }
}

