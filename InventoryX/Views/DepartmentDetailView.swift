//
//  AddDepartmentView.swift
//  InventoryX
//
//  Created by Ryan Smetana on 3/21/24.
//

import SwiftUI
import RealmSwift




class DepartmentDetailViewModel: ObservableObject {
    
    func saveDepartment(name: String, threshold: String, hasTax: Bool, markup: String) throws {
        // Make sure `threshold` was entered as a number
        guard let threshold = Int(threshold) else { throw AppError.numericThresholdRequired }
        
        let department = DepartmentEntity(name: name, restockNum: threshold)
        
        do {
//            try await DataService.addDepartment(dept: department)
            let realm = try Realm()
            try realm.write { realm.add(department) }
            print("Department saved successfully")
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
}

struct DepartmentDetailView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var vm: DepartmentDetailViewModel = DepartmentDetailViewModel()

    @State private var name: String = ""
    @State private var restockThreshold: String = ""
    @State private var hasTax: Bool = false
    @State private var markup: String = ""
    
    let department: DepartmentEntity?
    
    /// Used to hide the back button and title while onboarding.
    @State var showTitles: Bool
    
    /// Used in onboarding view to execute additional logic.
    let onSuccess: (() -> Void)?
    
    @State var detailState: DetailViewType
    
    init(department: DepartmentEntity?, showTitles: Bool = true, onSuccess: (() -> Void)? = nil) {
        if let dept = department {
            self.detailState = .modify
            self.name = dept.name
            self.restockThreshold = String(describing: dept.restockNumber)
//            self.hasTax = dept.hasTax
//            self.markup = dept.markup
            detailState = .modify
        } else {
            detailState = .create
        }
        self.department = department
        self.showTitles = showTitles
        self.onSuccess = onSuccess
    }
    
    private func continueTapped() {
        switch detailState {
        case .create:
            do {
                try vm.saveDepartment(name: name, threshold: restockThreshold, hasTax: hasTax, markup: markup)
                if showTitles {
                    dismiss()
                }
                onSuccess?()
            } catch {
                print("Error while saving company: \(error.localizedDescription)")
            }
        case .view:
            return
        case .modify:
            return
        }
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 32) {
            
            VStack(alignment: .leading) {
                if showTitles {
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
                
//                if isOnboarding {
//                    Text("You will be able to quickly search for your items by their department.")
//                        .font(.title3)
//                        .fontWeight(.regular)
//                        .fontDesign(.rounded)
//                        .frame(maxWidth: .infinity, alignment: .leading)
//                }
                
            } //: VStack
            .frame(maxWidth: 720)
            
            ThemeTextField(boundTo: $name,
                           placeholder: "i.e. Clothing",
                           title: "Department Name:",
                           subtitle: nil,
                           type: .text,
                           layout: .vertical)
//                .frame(maxHeight: 140)

//            Divider()
            
            VStack(spacing: 42) {
                
                ThemeTextField(boundTo: $restockThreshold,
                               placeholder: "0",
                               title: "Restock Threshold:",
                               subtitle: "This is the number that you want to restock the items in the department at. This will help you quickly find items that need to be restocked.",
                               type: .integer,
                               layout: .horizontal)
//                    .frame(maxHeight: 108)

                ThemeTextField(boundTo: $markup,
                               placeholder: "0",
                               title: "Default markup:",
                               subtitle: "When an item is added to this department it will be marked up by this percentage by default.",
                               type: .percentage,
                               layout: .horizontal)
//                    .frame(maxHeight: 72)
                
                Toggle(isOn: $hasTax) {
                    InputFieldLabel(title: "Tax free:", subtitle: "If you mark this department as tax free, when you sell items from this department tax will not be added.")
                        .padding(.trailing)
                        .frame(maxWidth: 420)
                    
                }
            } //: VStack
            .frame(maxWidth: 720)
            
            Spacer()
            
            Button {
                continueTapped()
                
            } label: {
                Text("Continue")
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
        .background(Color("Purple050").opacity(0.2))
//        .onAppear {
//            setup(forDepartment: department)
//            
//        }
        
    }
}

#Preview {
    DepartmentDetailView(department: nil) {}
}



