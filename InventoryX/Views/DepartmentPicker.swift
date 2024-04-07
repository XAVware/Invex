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
                .onAppear {
                    selectedDepartment = nil
                }
            
        case .list:         
            listStyle
            
        case .dropdown:
            dropDownStyle
                .onAppear {
                    if let dept = departments.first {
                        selectedDepartment = dept
                    }
                }
            
        case .columnHeaderBtn:
            columnHeaderStyle
                .onAppear {
                    if let dept = departments.first {
                        selectedDepartment = dept
                    }
                }
        }
    } //: Body
    
    private var scrollStyle: some View {
        ScrollView(.horizontal) {
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
            HStack {
                Spacer()
                Text(selectedDepartment?.name ?? "Select Department")
                Spacer()
                Image(systemName: "chevron.up.chevron.down")
                
            }
        }
        .padding()
        .frame(minWidth: 190, maxWidth: 220, alignment: .trailing)
        .frame(height: 56)
        .foregroundStyle(.black)
        .modifier(GlowingOutlineMod())
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
    DepartmentPicker(selectedDepartment: .constant(nil), style: .columnHeaderBtn)
        .padding()
        .environment(\.realm, DepartmentEntity.previewRealm)
}
