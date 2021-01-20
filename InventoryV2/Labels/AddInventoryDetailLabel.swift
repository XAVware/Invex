//
//  InventoryDetailLabel.swift
//  InventoryApp
//
//  Created by Ryan Smetana on 12/20/20.
//

import SwiftUI

struct AddInventoryDetailLabel: View {
    @State var title: String
    var body: some View {
        Text(self.title)
            .font(.system(size: 18, weight: .bold, design: .rounded))
            .foregroundColor(.black)
    }
}
