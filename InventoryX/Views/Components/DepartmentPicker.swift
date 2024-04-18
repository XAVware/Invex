//
//  MakeASaleView.swift
//  InventoryX
//
//  Created by Smetana, Ryan on 5/1/23.
//

import Foundation
import SwiftUI
import RealmSwift

struct DepartmentPicker: View {
    enum DepartmentPickerStyle { case scrolling, list, dropdown, columnHeaderBtn }
    @ObservedResults(DepartmentEntity.self) var departments
    /// When `selectedDepartment` is nil, the app displays all items in the view.
    @Binding var selectedDepartment: DepartmentEntity?
    @State var style: DepartmentPickerStyle
    
    var body: some View {
        switch style {
        case .scrolling:
            scrollStyle
            
        case .list:         
            listStyle
            
        case .dropdown:
            dropDownStyle
            
        case .columnHeaderBtn:
            columnHeaderStyle
        
        }
    } //: Body
    
    private var scrollStyle: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                Button {
                    selectedDepartment = nil
                } label: {
                    Text("All")
                        .modifier(DepartmentButtonMod(isSelected: selectedDepartment == nil))
                }
                
                ForEach(departments) { department in
                    Button {
                        selectedDepartment = department
                    } label: {
                        Text(department.name)
                            .modifier(DepartmentButtonMod(isSelected: selectedDepartment == department))
                    }
                } //: For Each
            } //: HStack
        } //: Scroll View
    } //: Scroll Style
    
    private var listStyle: some View {
        VStack(spacing: 16) {
            ForEach(departments) { department in
                Button {
                    selectedDepartment = department
                } label: {
                    HStack(spacing: 16) {
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text(department.name)
                                .font(.headline)
                                .fontDesign(.rounded)
                            
                            Text("\(department.items.count) Items")
                                .font(.subheadline)
                                .fontDesign(.rounded)
                                .foregroundStyle(.gray)
                        } //: VStack
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 12)
                            .foregroundStyle(.gray.opacity(0.6))
                            .fontWeight(.semibold)
                    } //: HStack
                    .background(selectedDepartment == department ? Color("Purple050").opacity(0.5) : nil)
                }
                Divider()
            } //: For Each
        } //: VStack
    } //: List Style
    
    private var dropDownStyle: some View {
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
                        .fill(.accent.opacity(0.9))
                        .opacity(0.8)
                        .frame(width: 48)
                    
                    Image(systemName: "building.2.fill")
                        .foregroundStyle(Color("Purple050"))
                        .font(.subheadline)
                        .fontDesign(.rounded)
                } //: ZStack
//                Spacer(minLength: 12)
                Text(selectedDepartment?.name ?? "Department")
                Spacer()
                Image(systemName: "chevron.up.chevron.down")
                    .padding(.trailing)
            }
        }
        .background(.white.opacity(0.95))
        .overlay(
            RoundedRectangle(cornerRadius: 6)
                .stroke(lineWidth: 0.5)
                .foregroundStyle(.gray)
                .shadow(color: Color("Purple050"), radius: 4, x: 3, y: 3)
                .shadow(color: Color("Purple050"), radius: 4, x: -3, y: -3)
        )
        .clipShape(RoundedRectangle(cornerRadius: 6))
        .shadow(color: Color.gray.opacity(0.20), radius: 4, x: 0, y: 0)
        .frame(minWidth: 190, maxWidth: 256, alignment: .trailing)
//        .frame(height: 48)
//        .foregroundStyle(.black)
//        .modifier(GlowingOutlineMod())
    } //: Drop Down Style
    
    private var columnHeaderStyle: some View {
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
            Text("Department")
                .padding(.horizontal)
            Image(systemName: "ellipsis")
        }
        .padding()
        .frame(minWidth: 190, maxWidth: .infinity)
        .frame(height: 56)
        .foregroundStyle(.black)
    } //: Drop Down Style
}


#Preview {
    DepartmentPicker(selectedDepartment: .constant(nil), style: .dropdown)
        .padding()
        .environment(\.realm, DepartmentEntity.previewRealm)
}
