//
//  DepartmentTableView.swift
//  InventoryX
//
//  Created by Ryan Smetana on 5/23/24.
//

import SwiftUI
import RealmSwift

struct DepartmentTableView: View {
    @ObservedResults(DepartmentEntity.self) var depts
    
    func onSelect(_ dept: DepartmentEntity) {
        LSXService.shared.update(newDisplay: .department(dept))
    }
    
    var body: some View {
        Table(of: DepartmentEntity.self) {
            TableColumn("Name") { dept in
                Text(dept.name)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .frame(height: 42)
                    .contentShape(Rectangle())
                    .onTapGesture { onSelect(dept) }
            }
            
            TableColumn("Restock at") { dept in
                Text(dept.formattedRestockNum)
                    .frame(height: 42)
                    .contentShape(Rectangle())
                    .onTapGesture { onSelect(dept) }
            }
            .alignment(.center)
            
            TableColumn("Def. Markup %") { dept in
                Text(dept.formattedMarkup)
                    .frame(height: 42)
                    .contentShape(Rectangle())
                    .onTapGesture { onSelect(dept) }
            }
            .alignment(.center)
            
            TableColumn("No. Items") { dept in
                Text(dept.itemCount)
                    .frame(height: 42)
                    .contentShape(Rectangle())
                    .onTapGesture { onSelect(dept) }
            }
            .alignment(.center)
            
        } rows: {
            ForEach(depts) {
                TableRow($0)
            }
        } //: Table
        .scrollContentBackground(.hidden)
        .padding(.vertical, 6)
        .frame(maxWidth: .infinity)
        
    }
    
}

#Preview {
    DepartmentTableView()
        .environment(\.realm, DepartmentEntity.previewRealm)
        .environment(NavigationService())
}
