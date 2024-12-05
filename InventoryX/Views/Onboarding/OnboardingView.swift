//
//  OnboardingView.swift
//  InventoryX
//
//  Created by Smetana, Ryan on 4/24/23.
//

import SwiftUI
import RealmSwift

struct OnboardingStepModel: Identifiable, Equatable {
    let id: UUID = UUID()
    let condition: Bool
    let title: String
    let description: String
    let destination: LSXDisplay
}

struct OnboardingView: View {
    @Environment(\.dismiss) var dismiss
    @State var path: NavigationPath = .init()
    
    @ObservedResults(DepartmentEntity.self) var departments
    @ObservedResults(CompanyEntity.self) var companies
    @ObservedResults(ItemEntity.self) var items
    
    var companyComplete: Bool {
        guard let c = companies.first else { return false }
        return !c.name.isEmpty
    }
    
    var departmentComplete: Bool { !departments.isEmpty }
    var itemComplete: Bool { !items.isEmpty }
    
    private func createDefaultCompany() throws {
        let realm = try Realm()
        try realm.write {
            realm.add(CompanyEntity())
        }
    }
    
    private func createDefaultDepartment() throws {
        let realm = try Realm()
        try realm.write {
            realm.add(DepartmentEntity())
        }
    }
    
    private func createDefaultItem() throws {
        let realm = try Realm()
        try realm.write {
            realm.add(ItemEntity())
        }
    }
    
    /// When the view appears, the first object in all collections if they do not already have an object.
    private func setup() {
        do {
            if companies.isEmpty {
                try createDefaultCompany()
            }
            
            if departments.isEmpty {
                try createDefaultDepartment()
            }
            
            if items.isEmpty {
                try createDefaultItem()
            }
            
        } catch {
            print("Error creating default company: \(error)")
        }
        
    }
    
    var body: some View {
        NavigationStack(path: $path) {
            let steps: [OnboardingStepModel] = [
                .init(condition: companyComplete,
                      title: "Add your company info",
                      description: "This will be used when calculating and displaying your sales.",
                      destination: .company),
                
                .init(condition: departmentComplete,
                      title: "Add a department",
                      description: "Your items will be grouped into departments.",
                      destination: .department(DepartmentEntity())),
                
                .init(condition: itemComplete,
                      title: "Add an item",
                      description: "You will be able to select items to add to the cart.",
                      destination: .item(ItemEntity()))
                ]
            
            FormX(title: "Setup") {
                VStack(spacing: 16) {
                    ForEach(steps) { step in
                        Button {
                            path.append(step.destination)
                        } label: {
                            HStack(spacing: 16) {
                                Image(systemName: step.condition ? "checkmark.square.fill" : "square")
                                    .font(.title2)
                                    .foregroundStyle(Color.accentColor)
                                
                                VStack(alignment: .leading) {
                                    Text(step.title)
                                        .font(.headline)
                                    
                                    Text(step.description)
                                        .font(.subheadline)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .opacity(0.5)
                                } //: VStack
                                .fontWeight(.medium)
                                .fontDesign(.rounded)
                                
                                Image(systemName: "chevron.right")
                                    .font(.title3)
                            } //: HStack
                        }
                        .buttonStyle(.plain)
                        
                        if step != steps.last {
                            Divider()
                        }
                    } //: For Each
                } //: VStack
                
                
                
            } //: Form X
            .overlay(
                Button {
                    dismiss()
                } label: {
                    Text("Get Started")
                        .frame(maxWidth: .infinity, maxHeight: 32, alignment: .center)
                        .font(.headline)
                }
                .buttonStyle(.borderedProminent)
                .padding()
                , alignment: .bottom)
            .navigationDestination(for: LSXDisplay.self) { view in
                switch view {
                case .company:
                    CompanyDetailView(company: companies.first ?? CompanyEntity())
                        .overlay(doneButton, alignment: .bottom)

                case .department(_):
                    DepartmentDetailView(department: departments.first ?? DepartmentEntity())
                    
                case .item(let i):
                    ItemDetailView(item: i)
                    
                default: Color.black
                }
                
            }
        } //: Navigation Stack
//        .onAppear {
//            setup()
//        }
        
        
//        NavigationStack(path: $path) {
//            LandingView(path: $path)
//                .navigationDestination(for: LSXDisplay.self) { view in
//                    switch view {
//                    case .company:
//                        CompanyDetailView(company: CompanyEntity()) {
////                            path.append(LSXDisplay.passcodePad([.set]))
//                            path.append(LSXDisplay.department(nil, .onboarding))
//                        }
//                        .background(Color.bg.ignoresSafeArea())
//
////                    case .passcodePad(let p):
////                        PasscodeX(processes: p) {
////                            path.append(LSXDisplay.department(nil, .onboarding))
////                        }
//                        
//                    case .department(let d, let t):
//                        DepartmentDetailView(department: d, detailType: t) {
//                            path.append(LSXDisplay.item(nil, .onboarding))
//                        }
//                        
//                    case .item(let i, let t):
//                        ItemDetailView(item: i, detailType: t) {
//                            dismiss()
//                        }
//                        
//                    default: Color.black
//                    }
//                    
//                }
//        } //: Navigation Stack
    } //: Body
    
    private var doneButton: some View {
        Button {
            path.removeLast()
        } label: {
            Text("Done")
                .frame(maxWidth: .infinity, maxHeight: 32, alignment: .center)
                .font(.headline)
        }
        .buttonStyle(.borderedProminent)
        .padding()
        

    }
}

#Preview {
    OnboardingView()
//        .environment(\.realm, DepartmentEntity.previewRealm)
}
