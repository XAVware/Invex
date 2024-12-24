//
//  DepartmentPickerX.swift
//  InventoryX
//
//  Created by Ryan Smetana on 12/10/24.
//

import SwiftUI
import RealmSwift

struct DepartmentPickerX: View {
    @Environment(FormXViewModel.self) var formVM
    @ObservedResults(DepartmentEntity.self) var departments
    @Binding var selectedDepartment: DepartmentEntity?
    @State var title: String
    @State var description: String
    let onChange: (DepartmentEntity) -> Void

    init(dept: Binding<DepartmentEntity?>, title: String, description: String, onChange: @escaping (DepartmentEntity) -> Void) {
        self._selectedDepartment = dept
        self.title = title
        self.description = description
        self.onChange = onChange
    }
    
    var body: some View {
        if formVM.expandedContainer == nil {
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text(title)
                    Text(description)
                        .opacity(0.5)
                    
                } //: VStack
                
                Spacer()
                
                Menu {
                    ForEach(departments) { dept in
                        Button(dept.name) {
                            onChange(dept)
                        }
                        .tag(dept)
                        
                    }
                } label: {
                    HStack {
                        Text(selectedDepartment?.name ?? "Select")
                        Image(systemName: "chevron.up.chevron.down")
                    }
                    .foregroundStyle(.black)
                }
                
                
//                Picker("", selection: $selectedDepartment) {
//                    ForEach(departments) { dept in
//                        Text(dept.name)
//                            .tag(DepartmentEntity?.none)
//                    }
//                }
//                .pickerStyle(MenuPickerStyle())
//                .tint(Color.textPrimary)
            } //: HStack
            .padding(.vertical)
        }
    }
}
