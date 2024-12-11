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
    
    init(dept: Binding<DepartmentEntity?>, title: String, description: String) {
        self._selectedDepartment = dept
        self.title = title
        self.description = description
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
                Picker("", selection: $selectedDepartment) {
                    ForEach(departments) { dept in
                        Text(dept.name)
                            .tag(DepartmentEntity?.none)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .tint(Color.textPrimary)
            } //: HStack
            .padding(.vertical)
        }
    }
}
