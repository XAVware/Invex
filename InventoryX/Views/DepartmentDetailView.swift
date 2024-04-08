//
//  AddDepartmentView.swift
//  InventoryX
//
//  Created by Ryan Smetana on 3/21/24.
//

import SwiftUI
import RealmSwift

@MainActor class DepartmentDetailViewModel: ObservableObject {
    
    func saveDepartment(name: String, threshold: String, markup: String) throws {
        // Make sure `threshold` was entered as a number
        guard let threshold = Int(threshold) else { throw AppError.numericThresholdRequired }
        guard let markup = Double(markup) else { return }
        
        let department = DepartmentEntity(name: name, restockNum: threshold, defMarkup: markup)
        let realm = try Realm()
        try realm.write {
            realm.add(department)
        }
//        LogService(self).info("New department saved successfully")
    }
    
    
    func updateDepartment(dept: DepartmentEntity, newName: String, thresh: String, markup: String) throws {
        guard let thresh = Int(thresh) else { throw AppError.numericThresholdRequired }
        guard let markup = Double(markup) else { throw AppError.invalidMarkup }
        guard let dept = dept.thaw() else { return }
        let realm = try Realm()
        try realm.write {
            dept.name = newName
            dept.restockNumber = thresh
            dept.defMarkup = markup
        }
//        LogService(self).info("Existing department successfully updated.")
    }
    
}

struct DepartmentDetailView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var vm: DepartmentDetailViewModel = DepartmentDetailViewModel()
    @StateObject var uiFeedback = UIFeedbackService.shared
    
    @State private var name: String = "Food"
    @State private var restockThreshold: String = "10"
    @State private var markup: String = "50"
    
    let department: DepartmentEntity
    
    /// Used to hide the back button and title while onboarding.
    @State var showTitles: Bool
    
    /// Used in onboarding view to execute additional logic.
    let onSuccess: (() -> Void)?
    
    let detailType: DetailViewType
    
    private enum Focus { case name, threshold, markup }
    @FocusState private var focus: Focus?
    
    init(department: DepartmentEntity, showTitles: Bool = true, onSuccess: (() -> Void)? = nil) {
        self.department = department
        self.showTitles = showTitles
        self.onSuccess = onSuccess
        self.detailType = department.name.isEmpty ? .create : .modify
    }
    
    // TODO: Move logic into VM.
    /// When the view is initialized, `detailType` is determined by whether a department was passed to the view or not. If it was, the department exists and should be modified otherwise the user is adding a department
    private func continueTapped() {
        focus = nil
        do {
            if detailType == .modify {
                try vm.updateDepartment(dept: department, newName: name, thresh: restockThreshold, markup: markup)
                LogService(self).info("Department udpated.")
            } else {
                try vm.saveDepartment(name: name, threshold: restockThreshold, markup: markup)
                LogService(self).info("Department created.")
            }
            
            finish()
        } catch {
            LogService(self).error("Error while saving department: \(error.localizedDescription)")
        }
    }
    
    private func finish() {
        if let onSuccess = onSuccess {
            // On success is only used by onboarding view which we don't want to dismiss.
            onSuccess()
        } else {
            dismiss()
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                header
                
                VStack(alignment: .leading, spacing: 24) {
                    ThemeTextField(boundTo: $name,
                                   placeholder: "i.e. Clothing",
                                   title: "Department Name:",
                                   subtitle: nil,
                                   type: .text)
                    .focused($focus, equals: .name)
                    
                    ThemeTextField(boundTo: $restockThreshold,
                                   placeholder: "0",
                                   title: "Restock Threshold:",
                                   subtitle: "This will help you quickly find items that need to be restocked.",
                                   type: .integer)
                    .keyboardType(.numberPad)
                    .focused($focus, equals: .threshold)
                    
                    ThemeTextField(boundTo: $markup,
                                   placeholder: "0",
                                   title: "Default markup:",
                                   subtitle: "When an item is added to this department it will be marked up by this percentage by default.",
                                   type: .percentage)
                    .keyboardType(.numberPad)
                    .focused($focus, equals: .markup)
                } //: VStack
                .padding(.vertical, 24)
                
                Button {
                    continueTapped()
                } label: {
                    Spacer()
                    Text("Continue")
                    Spacer()
                }
                .modifier(PrimaryButtonMod())
                
                Spacer()
            } //: VStack
            .frame(maxWidth: 720)
            .padding()
            .onAppear {
                name = department.name
                if department.restockNumber != 0 {
                    restockThreshold = String(describing: department.restockNumber)
                }
                
                if department.defMarkup != 0 {
                    markup = String(describing: department.defMarkup)
                }
            }
        } //: ScrollView
        .overlay(uiFeedback.alert != nil ? AlertView(alert: uiFeedback.alert!) : nil, alignment: .top)
    } //: Body
    
    @ViewBuilder private var header: some View {
        if showTitles {
            VStack(alignment: .leading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24)
                        .foregroundStyle(.black)
                }
                
                Text(detailType == .modify ? "Edit department" : "Add department")
                    .modifier(TitleMod())
                
            } //: VStack
            .frame(maxWidth: 720)
        }
    } //: Header
}

#Preview {
    DepartmentDetailView(department: DepartmentEntity())
}



