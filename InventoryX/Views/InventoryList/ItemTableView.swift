//
//  ItemTableView.swift
//  InventoryX
//
//  Created by Ryan Smetana on 5/21/24.
//

import SwiftUI
import RealmSwift

struct ItemTableView: View {
    @Environment(NavigationService.self) var navService
    @Environment(\.horizontalSizeClass) var horSize
    @ObservedResults(ItemEntity.self) var items
    
    @State private var sortOrder: [KeyPathComparator<ItemEntity>] = []
    
    func onSelect(_ item: ItemEntity) {
        print("Tapped")
        navService.path.append(LSXDisplay.item(item))
    }
    
    var body: some View {
//        VStack {
            
            Table(of: ItemEntity.self) {
                TableColumn("Name"/*, value: \.name*/) { item in
                    if horSize == .compact {
                        Text("\(item.name) - \(item.attribute)")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .frame(height: 42)
                            .contentShape(Rectangle())
                            .onTapGesture { onSelect(item) }
                    } else {
                        Text(item.name)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .frame(height: 42)
                            .contentShape(Rectangle())
                            .onTapGesture { onSelect(item) }
                    }
                }
                
                TableColumn("Attribute"/*, value: \.attribute*/) { item in
                    Text(item.attribute)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .frame(height: 42)
                        .contentShape(Rectangle())
                        .onTapGesture { onSelect(item) }
                }
                
                TableColumn("Stock"/*, value: \.onHandQty*/) { item in
                    Text(item.formattedQty)
                        .frame(height: 42)
                        .contentShape(Rectangle())
                        .onTapGesture { onSelect(item) }
                }
                .width(min: 96)
                .alignment(.center)
                
                TableColumn("Price"/*, value: \.retailPrice*/) { item in
                    Text(item.formattedPrice)
                        .frame(height: 42)
                        .contentShape(Rectangle())
                        .onTapGesture { onSelect(item) }
                }
                .width(max: 96)
                .alignment(.center)
                
                TableColumn("Cost"/*, value: \.unitCost*/) { item in
                    Text(item.formattedUnitCost)
                        .frame(height: 42)
                        .contentShape(Rectangle())
                        .onTapGesture { onSelect(item) }
                }
                .width(max: 96)
                .alignment(.center)
                
                TableColumn("") { item in
                    Text(item.restockWarning)
                        .frame(height: 42)
                        .contentShape(Rectangle())
                        .onTapGesture { onSelect(item) }
                }
                .width(24)
                .alignment(.center)
            } rows: {
                ForEach(items) {
                    TableRow($0)
                }
            } //: Table
            //        .onAppear {
            //            sortOrder = [KeyPathComparator(\ItemEntity.name)]
            //        }
            //        .onChange(of: sortOrder) { _, sortOrder in
            //            print(sortOrder.first == KeyPathComparator(\ItemEntity.name))
            //            print(sortOrder.first)
            //        }
            .scrollContentBackground(.hidden)
            .padding(.vertical, 6)
            .frame(maxWidth: .infinity)

//        }
    }
}

#Preview {
    ItemTableView()
        .environment(\.realm, DepartmentEntity.previewRealm)
        .environment(NavigationService())
}
