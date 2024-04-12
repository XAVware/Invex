//
//  InventoryListView.swift
//  InventoryX
//
//  Created by Ryan Smetana on 4/9/24.
//

import SwiftUI

struct InventoryListView: View {
    @State var selectedDepartment: DepartmentEntity?
    @State var selectedItem: ItemEntity?
    
    var body: some View {
        VStack {
            HStack {
                Text("Inventory List")
                Spacer()
                Button {
                    selectedItem = ItemEntity()
                } label: {
                    Image(systemName: "plus")
                }
            } //: HStack
            .padding()
            .font(.title)
            .fontDesign(.rounded)
            
            ResponsiveView { props in
                ItemTableView(department: $selectedDepartment, style: .list, uiProperties: props) { item in
                    self.selectedItem = item
                }
                .onAppear {
                    selectedDepartment = nil
                }
                .sheet(item: $selectedItem) { item in
                    AddItemView(item: item)
                }
            }
        } //: VStack
    }
}

#Preview {
    InventoryListView()
}
