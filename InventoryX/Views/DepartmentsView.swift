//
//  DepartmentsView.swift
//  InventoryX
//
//  Created by Ryan Smetana on 3/20/24.
//

import SwiftUI
import RealmSwift

struct DepartmentsView: View {
    @ObservedResults(DepartmentEntity.self) var departments
    @State var selectedDepartment: DepartmentEntity?
    
    @State var columnData: [ColumnHeaderModel] = [
        ColumnHeaderModel(headerText: "Department Name", sortDescriptor: "dept"),
        ColumnHeaderModel(headerText: "No. Items", sortDescriptor: "name"),
        ColumnHeaderModel(headerText: "Default Markup %", sortDescriptor: "onHandQty"),
        ColumnHeaderModel(headerText: "Restock Threshold", sortDescriptor: "retailPrice")
    ]
    
    var body: some View {
        VStack {
            HStack(spacing: 0) {
                Text("Departments")
                Spacer()
                Button {
                    selectedDepartment = DepartmentEntity()
                } label: {
                    Image(systemName: "plus")
                }
            } //: HStack
            .padding()
            .font(.title)
            .fontDesign(.rounded)
            
            VStack {
                HStack(spacing: 0) {
                    ForEach(columnData) { header in
                        HStack {
                            Text(header.headerText)
                                .font(.body)
                                .fontWeight(.semibold)
                                .fontDesign(.rounded)
                            
                        } //: HStack
                        .frame(maxWidth: .infinity)
                        .frame(height: 64)
                        .background(Color("Purple050").opacity(0.5))
                    }
                } //: HStack
                
                ForEach(departments) { dept in
                    HStack(spacing: 0) {
                        
                        Text(dept.name)
                            .frame(maxWidth: .infinity)
                        
                        Text(dept.items.count.description)
                            .frame(maxWidth: .infinity)
                        
                        Text(dept.defMarkup.description)
                            .frame(maxWidth: .infinity)
                        
                        Text(dept.restockNumber.description)
                            .frame(maxWidth: .infinity)
                        
                    } //: HStack
                    .background(.white.opacity(0.01))
                    .frame(height: 64)
                    .onTapGesture {
                        selectedDepartment = dept
                    }
                    
                    Divider().opacity(0.4)
                } //: For Each
                
            } //: VStack
            .modifier(TableStyleMod())
            .sheet(item: $selectedDepartment) { dept in
                DepartmentDetailView(department: dept)
                    .overlay(AlertView())
            }
            
            Spacer()
        } //: VStack - Departments List
    } //: Body
}

#Preview {
    ResponsiveView { props in
        NavigationStack {
            DepartmentsView()
                .environment(\.realm, DepartmentEntity.previewRealm)
        }
    }
}



