//
//  AddDepartmentView.swift
//  InventoryX
//
//  Created by Ryan Smetana on 3/21/24.
//

import SwiftUI
import RealmSwift




class DepartmentDetailViewModel: ObservableObject {
    
    func saveDepartment(name: String, threshold: String, markup: String) throws {
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
    @Environment(\.horizontalSizeClass) var hSize
    @StateObject var vm: DepartmentDetailViewModel = DepartmentDetailViewModel()
    
    @State private var name: String = ""
    @State private var restockThreshold: String = ""
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
                try vm.saveDepartment(name: name, threshold: restockThreshold, markup: markup)
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
        ScrollView {
            VStack(spacing: 32) {
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
                        Text("Add a department")
                            .modifier(TitleMod())
                    }
                } //: VStack
                
                VStack(alignment: .leading, spacing: 32) {
                    ThemeTextField(boundTo: $name,
                                   placeholder: "i.e. Clothing",
                                   title: "Department Name:",
                                   subtitle: nil,
                                   type: .text)
                    
                    ThemeTextField(boundTo: $restockThreshold,
                                   placeholder: "0",
                                   title: "Restock Threshold:",
                                   subtitle: "This will help you quickly find items that need to be restocked.",
                                   type: .integer)
                    
                    ThemeTextField(boundTo: $markup,
                                   placeholder: "0",
                                   title: "Default markup:",
                                   subtitle: "When an item is added to this department it will be marked up by this percentage by default.",
                                   type: .percentage)
                } //: VStack
                
                Spacer()
                
                Button {
                    continueTapped()
                    
                } label: {
                    Text("Continue")
                }
                .modifier(PrimaryButtonMod())
                
                Spacer()
            } //: VStack
            .frame(maxWidth: 720)
            .padding()
            .toolbar(.hidden, for: .navigationBar)
            //        .background(Color("Purple050").opacity(0.2))
            //        .onAppear {
            //            setup(forDepartment: department)
            //
            //        }
        }
    }
    
}

#Preview {
    DepartmentDetailView(department: nil)
}



