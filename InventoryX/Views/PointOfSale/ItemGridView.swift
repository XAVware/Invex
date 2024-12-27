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
    private let columns: [GridItem] = [ GridItem(.adaptive(minimum: 160, maximum: .infinity), spacing: 12) ]
    @State var department: DepartmentEntity?
    let onSelect: ((ItemEntity) -> Void)
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(getItems()) { item in
                    Button {
                        UIImpactFeedbackGenerator(style: .light).impactOccurred(intensity: 0.9)
                        onSelect(item)
                    } label: {
                        ItemGridButtonLabel(item: item)
                    }
                } //: ForEach
            } //: LazyVGrid
            .padding(2)
        } //: Scroll
        .scrollIndicators(.hidden)
    } //: Body
    
    private func getItems() -> [ItemEntity] {
        if let department {
            return Array(department.items.sorted(by: \.name, ascending: true))
        } else {
            return Array(items)
        }
    }
}

// MARK: - Item Grid Button Label
struct ItemGridButtonLabel: View {
    let item: ItemEntity
    
    var body: some View {
        Grid(alignment: .leading) {
            Text(item.name)
                .fontWeight(.semibold)
                .font(.headline)
            
            GridRow(alignment: .bottom) {
                Text(item.attribute)
                    .fontWeight(.thin)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(item.formattedPrice)
            }
            .font(.subheadline)
        }
        .foregroundStyle(Color.textDark)
        .padding(10)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .fontDesign(.rounded)
        .background(.ultraThinMaterial)
        .overlay(
            RoundedRectangle(cornerRadius: 6)
                .stroke(Color.accentColor.opacity(0.1), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 6))
    }
}


//#Preview {
//    ItemGridView(items: ItemEntity.drinkArray) { i in
//
//    }
//    .padding()
//    .environment(\.realm, DepartmentEntity.previewRealm)
//
//}
