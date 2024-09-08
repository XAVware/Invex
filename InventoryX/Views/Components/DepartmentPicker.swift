//
//  MakeASaleView.swift
//  InventoryX
//
//  Created by Smetana, Ryan on 5/1/23.
//

import SwiftUI
import RealmSwift

struct DepartmentPicker: View {
    @ObservedResults(DepartmentEntity.self) var departments
    @Binding var selectedDepartment: DepartmentEntity?
    
    var body: some View {
        Menu {
            ForEach(departments) { department in
                Button {
                    selectedDepartment = department
                } label: {
                    Text(department.name)
                }
                .tag(department as DepartmentEntity?)
            }
        } label: {
            HStack(spacing: 12) {
                ZStack {
                    Rectangle()
                        .fill(.accent)
                        .opacity(0.8)
                        .frame(width: 48)
                    
                    Image(systemName: "building.2.fill")
//                        .foregroundStyle(Color("lightAccent"))
                        .font(.subheadline)
                        .fontDesign(.rounded)
                } //: ZStack
                Text(selectedDepartment?.name ?? "Department")
                Spacer()
                Image(systemName: "chevron.up.chevron.down")
                    .padding(.trailing)
            }
        }
        .background(.ultraThickMaterial)
        .overlay(
            RoundedRectangle(cornerRadius: 6)
                .stroke(lineWidth: 0.5)
                .foregroundStyle(Color.textSecondary.opacity(0.4))
                .shadow(color: Color.bg, radius: 4, x: 3, y: 3)
                .shadow(color: Color.bg, radius: 4, x: -3, y: -3)
        )
        .clipShape(RoundedRectangle(cornerRadius: 6))
//        .shadow(color: Color("ShadowColor"), radius: 4, x: 0, y: 0)
        .frame(minWidth: 190, maxWidth: 256, alignment: .trailing)
    } //: Body
    
    
}


//#Preview {
//    DepartmentPicker(selectedDepartment: .constant(nil), style: .dropdown)
//        .padding()
//        .environment(\.realm, DepartmentEntity.previewRealm)
//}
