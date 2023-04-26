//
//  SectionHeader.swift
//  InventoryX
//
//  Created by Smetana, Ryan on 4/25/23.
//

import SwiftUI

struct SectionHeader: View {
    enum Section { case addCategory, restockThreshold, adminSetup, email }
    let section: Section
    let alignment: TextAlignment
    let horizontalAlignment: HorizontalAlignment
    
    init(section: Section, alignment: TextAlignment = .leading) {
        self.section = section
        self.alignment = alignment
        
        switch alignment {
        case .center:
            horizontalAlignment = .center
        case .leading:
            horizontalAlignment = .leading
        case .trailing:
            horizontalAlignment = .trailing
        }
    }
    
    var header: String {
        switch section {
        case .addCategory:
            return "Add A Category"
        case .restockThreshold:
            return "Restock Threshold"
        case .adminSetup:
            return "Create Admin Profile"
        case .email:
            return "Add An Email"
        }
    }
    
    var detail: String {
        switch section {
        case .addCategory:
            return "Your inventory will be displayed based on their category."
        case .restockThreshold:
            return "If an item reaches its category's restock threshold, InventoryX will alert you."
        case .adminSetup:
            return "Your admin profile will give you full access to the app. You can create other accounts later."
        case .email:
            return "If you add an email you can receive email notifications when item inventory is low."
        }
    }
    
    var body: some View {
        VStack(alignment: horizontalAlignment, spacing: 8) {
            Text(header)
                .modifier(TextMod(.title, .bold, .black))
            
            Text(detail)
                .modifier(TextMod(.footnote, .semibold, .gray))
                .multilineTextAlignment(alignment)
                
        } //: VStack
    }
}

struct SectionHeader_Previews: PreviewProvider {
    static var previews: some View {
        SectionHeader(section: .addCategory)
    }
}
