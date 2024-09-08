//
//  ItemTableView.swift
//  InventoryX
//
//  Created by Ryan Smetana on 3/21/24.
//

import SwiftUI

struct ItemGridView: View {
    @Environment(\.horizontalSizeClass) var horSize
    @Environment(\.verticalSizeClass) var verSize
    @Environment(\.colorScheme) var colorScheme
    let onSelect: ((ItemEntity) -> Void)
    let items: Array<ItemEntity>
    let colSpacing: CGFloat = 8
    let rowSpacing: CGFloat = 8
    
    init(items: Array<ItemEntity>, onSelect: @escaping ((ItemEntity) -> Void)) {
        self.items = items
        self.onSelect = onSelect
    }
    
    var body: some View {
        GeometryReader { geo in
            let targetButtonWidth: CGFloat = verSize == .compact  || horSize == .compact ? 150 : 180
            let maxColsForWidth: CGFloat = floor(geo.size.width / (targetButtonWidth + colSpacing))
            
            ScrollView {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: colSpacing), count: Int(maxColsForWidth)) , alignment: .leading, spacing: rowSpacing) {
                    ForEach(items) { item in
                        Button {
                            UIImpactFeedbackGenerator(style: .light).impactOccurred(intensity: 0.9)
                            onSelect(item)
                        } label: {
                            ZStack {
                                NeomorphicCardView(layer: .over)
                                    .blendMode(colorScheme == .dark ? .plusLighter : .plusDarker)
                                VStack(alignment: .leading, spacing: 0) {
                                    Text(item.name)
                                        .font(.headline)
                                        .foregroundStyle(Color.textPrimary)
                                    
                                    Spacer()
                                    
                                    Text(item.attribute)
                                        .font(.subheadline)
                                        .foregroundStyle(Color.textPrimary) 
                                    
                                    Spacer()
                                    
                                    Text(item.retailPrice.formatAsCurrencyString())
                                        .font(.headline)
                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                        .foregroundStyle(.accent)
                                } //: VStack
                                .fontDesign(.rounded)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                            }
                            .padding(4)

                            
                        }
                    } //: ForEach
                } //: LazyVGrid
                .padding(2)
            } //: Scroll
        } //: Geometry Reader
        .scrollIndicators(.hidden)
    } //: Body
    
    
}


//#Preview {
//    ItemGridView(items: ItemEntity.drinkArray) { i in
//        
//    }
//    .padding()
//    .background(.ultraThickMaterial)
//    .environment(\.realm, DepartmentEntity.previewRealm)
//    
//}
