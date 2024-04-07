//
//  DepartmentsView.swift
//  InventoryX
//
//  Created by Ryan Smetana on 3/20/24.
//

import SwiftUI
import RealmSwift

struct DepartmentsView: View {    
    @State var department: DepartmentEntity?
    
    @State var showDepartmentsView: Bool = false
    
    var body: some View {
        HStack {
            VStack {
                HStack(alignment: .bottom) {
                    HStack(spacing: 0) {
                        
                        Text("Departments")
                            .font(.title)
                            .fontDesign(.rounded)
                            .padding(.horizontal)
                        
                        
                        Button {
                            showDepartmentsView = true
                        } label: {
                            Image(systemName: "plus")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 12)
                                .foregroundStyle(Theme.primaryColor)
                            
                            Text("Add Department")
                                .foregroundStyle(.black)
                        }
                        .padding(8)
                        .background(Color("Purple050"))
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                        .shadow(radius: 2)
                        .sheet(item: $department, onDismiss: {
                            department = nil
                        }, content: { dept in
                            DepartmentDetailView(department: dept)
                        })
                    } //: HStack
                    
                    Spacer()
                    
                } //: HStack
                
                DepartmentPicker(selectedDepartment: $department, style: .list)
                
                Spacer()
            } //: VStack - Departments List
            .frame(maxWidth: 420)
            Spacer()
        } //: HStack
        .padding()
        
        
    }
}

#Preview {
    ResponsiveView { props in
        NavigationStack {
            DepartmentsView()
            //            AddDepartmentView(department: DepartmentEntity())
                .environment(\.realm, DepartmentEntity.previewRealm)
        }
    }
    //    DepartmentsView()
}



