//
//  SectionHeader.swift
//  InventoryX
//
//  Created by Smetana, Ryan on 4/25/23.
//

import SwiftUI

struct SectionHeader: View {
    enum Section { case  itemName, itemPrice, itemCategory }
    let section: Section
    let alignment: TextAlignment
    let horizontalAlignment: HorizontalAlignment
    let showsHeader: Bool
    let showsDetail: Bool
    
    init(section: Section, alignment: TextAlignment = .leading, showsHeader: Bool = true, showsDetail: Bool = true) {
        self.section = section
        self.alignment = alignment
        self.showsHeader = showsHeader
        self.showsDetail = showsDetail
        
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
        switch section {        case .itemName:
            return "Add An Item"
        case .itemPrice:
            return "Price"
        case .itemCategory:
            return "Category"
        }
    }
    
    var detail: String {
        switch section {
        case .itemName:
            return "Add An Item"
        case .itemPrice:
            return "How much do you sell this item for?"
        case .itemCategory:
            return "Which category does this item fall under?"
        }
    }
    
    var body: some View {
        VStack(alignment: horizontalAlignment, spacing: 8) {
            if showsHeader {
                Text(header)
                    .modifier(TextMod(.title3, .bold, .black))
            }
            
            if showsDetail {
                Text(detail)
                    .modifier(TextMod(.footnote, .thin, .black))
                    .multilineTextAlignment(alignment)
            }
        } //: VStack
    }
}

struct SectionHeader_Previews: PreviewProvider {
    static var previews: some View {
        SectionHeader(section: .itemName)
    }
}
