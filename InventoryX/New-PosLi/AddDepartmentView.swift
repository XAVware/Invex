//
//  AddDepartmentView.swift
//  InventoryX
//
//  Created by Ryan Smetana on 3/21/24.
//

import SwiftUI

enum AppError: Error {
    case departmentAlreadyExists
    case numericThresholdRequired
    
    var localizedDescription: String {
        switch self {
        case .departmentAlreadyExists: "Department already exists with this name"
        case .numericThresholdRequired:          "Please enter a valid number for the restock threshold"
        }
    }
}


class AddDepartmentViewModel: ObservableObject {
    
    func saveDepartment(name: String, threshold: String, hasTax: Bool, markup: Double) async throws {
        // Make sure `threshold` was entered as a number
        guard let threshold = Int(threshold) else { return }
        
        let department = DepartmentEntity(name: name, restockNum: threshold)
        
        do {
            try await DataService.addDepartment(dept: department)
            print("Department saved successfully")
        } catch {
            print(error.localizedDescription)
        }

    }
    
}

struct AddDepartmentView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var vm: AddDepartmentViewModel = AddDepartmentViewModel()
    
    @State var department: DepartmentEntity?
    
    @State var name: String = ""
    @State var restockThreshold: String = ""
    @State var hasTax: Bool = false
    @State var markup: Double = 0.00
    
    @State var isEditing: Bool = false
    
    func setup(forDepartment department: DepartmentEntity?) {
        if let dept = department {
            self.name = dept.name
        } else {
            self.isEditing = true
        }
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 32) {
            
            VStack(alignment: .leading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24)
                        .foregroundStyle(Theme.primaryColor)
                }
                Text("Add a department")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .fontDesign(.rounded)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
            } //: VStack
            
            VStack(alignment: .leading, spacing: 16) {
                
                VStack(alignment: .leading) {
                    Text("Department Name:")
                        .modifier(FieldTitleMod())
                } //: VStack
                
                TextField("i.e. Clothing", text: $name)
                    .modifier(ThemeFieldMod())
                
            } //: VStack - Department Name
            
            HStack(spacing: 16) {
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Restock Threshold:")
                        .modifier(FieldTitleMod())
                    
                    Text("This is the number that you want to restock the items in the department at. This will help you quickly find items that need to be restocked.")
                        .modifier(FieldSubtitleMod())
                } //: VStack
                Spacer()
                TextField("0", text: $restockThreshold)
                    .modifier(ThemeFieldMod())
                    .frame(maxWidth: 200)
                
            } //: VStack - Restock Threshold
            
            HStack(spacing: 16) {
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Default markup:")
                        .modifier(FieldTitleMod())
                    
                    Text("When an item is added to this department it will be marked up by this percentage by default.")
                        .modifier(FieldSubtitleMod())
                } //: VStack
                
                Spacer()
                
                TextField("0", text: $restockThreshold)
                    .modifier(ThemeFieldMod(overlayText: "%"))
                    .frame(maxWidth: 200)
            } //: VStack - Restock Threshold
            
            Toggle(isOn: $hasTax, label: {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Tax free")
                        .modifier(FieldTitleMod())
                    
                    Text("If you mark this department as tax free, when you sell items from this department tax will not be added.")
                        .modifier(FieldSubtitleMod())
                    
                } //: VStack
            })
            
            Spacer()
            
            Button {
                Task {
                    try await vm.saveDepartment(name: name, threshold: restockThreshold, hasTax: hasTax, markup: markup)
                    dismiss()
                }
            } label: {
                Text("Save Department")
            }
            .modifier(PrimaryButtonMod())
            Spacer()
        } //: VStack
        .overlay(
            Image(systemName: "building.2.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 72)
                .foregroundColor(Color("Purple800"))
                .opacity(0.2)
            ,alignment: .topTrailing
        )
        .padding()
        .toolbar(.hidden, for: .navigationBar)
        .background(Color("Purple050").opacity(0.3))
        .onAppear {
            setup(forDepartment: department)
            
        }
        
    }
}

#Preview {
    AddDepartmentView(department: nil)
}
