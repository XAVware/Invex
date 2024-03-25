//
//  DepartmentsView.swift
//  InventoryX
//
//  Created by Ryan Smetana on 3/20/24.
//

import SwiftUI
import RealmSwift

struct DepartmentsView: View {    
    @State var selectedDepartment: DepartmentEntity?
    
    @State var showAddDepartment: Bool = false
    
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
                            showAddDepartment = true
                        } label: {
                            Image(systemName: "plus")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 12)
                                .foregroundStyle(.white)
                            
                        }
                        .padding(6)
                        .background(Color("Purple800"))
                        .clipShape(RoundedRectangle(cornerRadius: 24))
                        .shadow(radius: 2)
                    } //: HStack
                    
                    Spacer()
                    
                } //: HStack
                
                DepartmentPicker(selectedDepartment: $selectedDepartment, style: .list)
                
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



