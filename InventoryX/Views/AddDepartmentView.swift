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
        case .departmentAlreadyExists:      "Department already exists with this name"
        case .numericThresholdRequired:     "Please enter a valid number for the restock threshold"
        }
    }
}


class AddDepartmentViewModel: ObservableObject {
    
    func saveDepartment(name: String, threshold: String, hasTax: Bool, markup: String) async throws {
        // Make sure `threshold` was entered as a number
        guard let threshold = Int(threshold) else { throw AppError.numericThresholdRequired }
        
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
    @State var markup: String = ""
    
    @State var isEditing: Bool = false
    
    @State var isOnboarding: Bool = false
    let completion: (() -> Void)?
    
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
                if !isOnboarding {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24)
                            .foregroundStyle(.black)
                    }
                }
                
                Text("Add a department")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .fontDesign(.rounded)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                if isOnboarding {
                    Text("You will be able to quickly search for your items by their department.")
                        .font(.title3)
                        .fontWeight(.regular)
                        .fontDesign(.rounded)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
            } //: VStack
            .frame(maxWidth: 720)
            
            HStack {
                VStack(alignment: .leading, spacing: 16) {
                    InputFieldLabel(title: "Department Name:", subtitle: nil)
                        .frame(maxWidth: 420, alignment: .leading)
                    
                    TextField("i.e. Clothing", text: $name)
                        .modifier(ThemeFieldMod())
//                        .frame(maxWidth: 320)
                } //: VStack - Department Name
                
                Spacer()
            } //: HStack
            .frame(maxWidth: 720)
            
            Divider()
            
            VStack(spacing: 42) {
                HStack(spacing: 16) {
                    InputFieldLabel(title: "Restock Threshold:", subtitle: "This is the number that you want to restock the items in the department at. This will help you quickly find items that need to be restocked.")
                        .frame(maxWidth: 420)
                    
                    Spacer()
                    
                    TextField("0", text: $restockThreshold)
                        .modifier(ThemeFieldMod(overlayText: "123"))
                        .frame(maxWidth: 120)
                    
                } //: HStack - Restock Threshold
                .frame(maxWidth: 720)
                
                
                HStack(spacing: 16) {
                    InputFieldLabel(title: "Default markup:", subtitle: "When an item is added to this department it will be marked up by this percentage by default.")
                        .frame(maxWidth: 420)
                    
                    Spacer()
                    
                    TextField("0", text: $markup)
                        .modifier(ThemeFieldMod(overlayText: "%"))
                        .frame(maxWidth: 120)
                } //: HStack - Markup
                .frame(maxWidth: 720)
                
                
                Toggle(isOn: $hasTax) {
                    InputFieldLabel(title: "Tax free:", subtitle: "If you mark this department as tax free, when you sell items from this department tax will not be added.")
                        .padding(.trailing)
                        .frame(maxWidth: 420)
                    
                }
                .frame(maxWidth: 720)
            } //: VStack
            
            Spacer()
            
            Button {
                Task {
                    do {
                        try await vm.saveDepartment(name: name, threshold: restockThreshold, hasTax: hasTax, markup: markup)
                        if !isOnboarding {
                            dismiss()
                        } else {
                            completion?()
                        }
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            } label: {
                Text(isOnboarding ? "Continue" : "Save Department")
            }
            .modifier(PrimaryButtonMod())
            
            Spacer()
        } //: VStack
        .overlay(
            Image(systemName: "building.2.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 96)
                .foregroundColor(Color("Purple800"))
                .opacity(0.1)
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
    AddDepartmentView(department: nil) {}
}
