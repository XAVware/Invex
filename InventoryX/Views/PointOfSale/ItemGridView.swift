//
//  ItemTableView.swift
//  InventoryX
//
//  Created by Ryan Smetana on 3/21/24.
//

import SwiftUI
import RealmSwift

struct ItemGridView: View {
    @ObservedResults(ItemEntity.self, sortDescriptor: SortDescriptor(keyPath: "name", ascending: true)) var items
    @State var department: DepartmentEntity?
    let onSelect: ((ItemEntity) -> Void)
    
    private func getItems() -> [ItemEntity] {
        if let department {
            return Array(department.items.sorted(by: \.name, ascending: true))
        } else {
            return Array(items)
        }
    }
    
    let columns: [GridItem] = [ GridItem(.adaptive(minimum: 240, maximum: .infinity), spacing: 16) ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(getItems()) { item in
                    Button {
                        UIImpactFeedbackGenerator(style: .light).impactOccurred(intensity: 0.9)
                        onSelect(item)
                    } label: {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(item.name)
                                    .fontWeight(.bold)
                                
                                Text(item.attribute)
                                    .fontWeight(.regular)
                            } //: VStack
                            .font(.headline)
                            .foregroundStyle(Color.textPrimary)
                            
                            Spacer()
                            
                            Text(item.formattedPrice)
                                .foregroundStyle(Color.accentColor)
                        } //: HStack
                        .padding(12)
                        .fontDesign(.rounded)
                        .background(.ultraThinMaterial)
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(Color.accentColor.opacity(0.1), lineWidth: 1)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                    }
                } //: ForEach
            } //: LazyVGrid
            .padding(2)
        } //: Scroll
//        .background(Color.accentColor.opacity(0.007))
        .scrollIndicators(.hidden)
    } //: Body
    
    
}


//#Preview {
//    ItemGridView(items: ItemEntity.drinkArray) { i in
//
//    }
//    .padding()
//    .environment(\.realm, DepartmentEntity.previewRealm)
//
//}
