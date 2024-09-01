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
                                VStack(alignment: .leading, spacing: 0) {
                                    Text(item.name)
                                        .font(.headline)
                                        .foregroundStyle(Color("TextColor"))
                                    
                                    Spacer()
                                    
                                    Text(item.attribute)
                                        .font(.subheadline)
                                        .foregroundStyle(Color("TextColor"))
                                    
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

    
//                            .background(
//                                Color.lightAccent
//                                    .opacity(0.8)
//                                    .clipShape(RoundedRectangle(cornerRadius: 8))
//                                    .blur(radius: 3)
//                                    .shadow(color: Color.lightButtonGradient1, radius: 1, x: 2, y: 2)
//                                    .shadow(color: Color.lightButtonGradient2, radius: 1, x: -2, y: -2)
//                            )
                            
                            
                            //                    .background(.lightAccent)
                            //                    .background(.thinMaterial)
                            //                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            //                    .shadow(color: .lightButtonStroke2, radius: 3, x: 1, y: 1)
                            //                    .background(
                            //                        LinearGradient(colors: [Color.lightButtonGradient1,
                            ////                                                Color.lightButtonGradientBase,
                            //                                                Color.lightButtonGradient3,
                            //                                                Color.lightButtonGradient1],
                            //                                       startPoint: .topLeading,
                            //                                       endPoint: .bottomTrailing)
                            //                        .opacity(0.2)
                            //                    )
                            //                    .modifier(GridButtonMod())
                            //                    .frame(maxWidth: .infinity, alignment: .leading)
                            
                        }
                        //                    .buttonStyle(BorderedProminentButtonStyle())
                        //                    .buttonBorderShape(.roundedRectangle(radius: 12))
                        
                        
                        
                    } //: ForEach
                } //: LazyVGrid
                .padding(2)
            } //: Scroll
        } //: Geometry Reader
        .scrollIndicators(.hidden)
    } //: Body
    
    
    struct GridButtonMod: ViewModifier {
        @Environment(\.colorScheme) private var colorScheme
        func body(content: Content) -> some View {
            switch colorScheme {
            case .dark:
                content
                    .background(
                        ZStack {
                            Color.darkButtonGradientBase
                            LinearGradient(colors: [Color.darkButtonGradient1,
                                                    Color.darkButtonGradientBase,
                                                    Color.darkButtonGradient3],
                                           startPoint: .topLeading,
                                           endPoint: .bottomTrailing)
                            .opacity(0.2)
                            
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(LinearGradient(colors: [Color.darkButtonStroke1,
                                                                Color.darkButtonStroke2],
                                                       startPoint: .topLeading,
                                                       endPoint: .bottomTrailing), lineWidth: 4)
                        }
                            .opacity(0.9)
                            .blur(radius: 3)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .shadow(color: Color.darkButtonStroke1, radius: 3, x: 2, y: 2)
                    .shadow(color: Color.darkButtonStroke2, radius: 3, x: -3, y: -3)
                    .opacity(0.6)
                
            default:
                content
                    .background(
                        ZStack {
                            Color.lightButtonGradientBase
                            
                            LinearGradient(colors: [Color.lightButtonStroke1,
                                                    //                                                    Color.lightButtonGradientBase,
                                                    Color.lightButtonStroke2],
                                           startPoint: .topLeading,
                                           endPoint: .bottomTrailing)
                            .opacity(0.4)
                            
                            
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(LinearGradient(colors: [Color.lightButtonStroke1,
                                                                Color.lightButtonStroke2.opacity(0.8)],
                                                       startPoint: .topLeading,
                                                       endPoint: .bottomTrailing), lineWidth: 4)
                        } //: ZStack
                            .blur(radius: 2)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .shadow(color: .lightButtonStroke1, radius: 2, x: 2, y: 2)
                    .shadow(color: .lightButtonStroke2, radius: 2, x: -2, y: -2)
                
            }
            
        }
    }
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
