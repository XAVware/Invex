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
    
    let columns: [GridItem] = [
        GridItem(.adaptive(minimum: 240, maximum: .infinity), spacing: 16),
    ]
    var body: some View {
        GeometryReader { geo in

            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(items, id: \.self) { item in
                        Button {
                            UIImpactFeedbackGenerator(style: .light).impactOccurred(intensity: 0.9)
                            onSelect(item)
                        } label: {
                            HStack(spacing: 0) {
                                Color.accentColor.opacity(0.07)
                                    .ignoresSafeArea()
                                    .frame(width: 16)
                                
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(item.name)
                                            .fontWeight(.bold)
                                        
//                                        Spacer()
                                        Text(item.attribute)
                                    } //: VStack
                                    .font(.subheadline)
                                    .foregroundStyle(Color.textPrimary)
                                    
                                    Spacer()
                                    Text(item.formattedPrice)
                                        .foregroundStyle(Color.accentColor)
    //                                VStack {
    //                                    Spacer()
    //                                    Text(item.formattedPrice)
    //                                        .font(.regular)
    //                                        .frame(maxWidth: .infinity, alignment: .trailing)
    //                                } //: VStack
                                } //: HStack
    //
    //                            } //: VStack
                                .padding(10)
//                                .padding(.horizontal, 4)
                                .fontDesign(.rounded)
                            }
//                            .background(Color.fafafa)
                            .background(.ultraThinMaterial)
                            .overlay(
                                RoundedRectangle(cornerRadius: 6)
                                    .stroke(Color.accentColor.opacity(0.1), lineWidth: 01)
                            )
                        }
//                        .padding(.horizontal, 12)
//                        .padding(.vertical, 6)
                    } //: ForEach
                } //: LazyVGrid
                .padding(2)
            } //: Scroll
            //            .background(Color.fafafa)
            .background(Color.accentColor.opacity(0.007))
            
        } //: Geometry Reader
        .scrollIndicators(.hidden)
    } //: Body
    
    
}


#Preview {
    ItemGridView(items: ItemEntity.drinkArray) { i in
        
    }
    .padding()
    //    .padding()
    //    .background(.ultraThickMaterial)
    .environment(\.realm, DepartmentEntity.previewRealm)
    
}
