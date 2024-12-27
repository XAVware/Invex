//
//  OnboardingView.swift
//  InventoryX
//
//  Created by Smetana, Ryan on 4/24/23.
//

import SwiftUI
import RealmSwift

// MARK: - Models
struct OnboardingStepModel: Identifiable, Equatable {
    let id: UUID = UUID()
    let condition: Bool
    let title: String
    let description: String
    let destination: LSXDisplay
    let isEnabled: Bool
}

// MARK: - ViewModel
class OnboardingViewModel: ObservableObject {
    @Published private(set) var isSetupComplete = false
    private let realm: Realm?
    
    init() {
        realm = try? Realm()
    }
    
    func setupDefaultObjects() {
        guard let realm else { return }
        
        // Perform all writes in a single transaction
        do {
            try realm.write {
                if realm.objects(CompanyEntity.self).isEmpty {
                    realm.add(CompanyEntity())
                }
                
                if realm.objects(DepartmentEntity.self).isEmpty {
                    realm.add(DepartmentEntity())
                }
                
                if realm.objects(ItemEntity.self).isEmpty {
                    realm.add(ItemEntity())
                }
            }
        } catch {
            print("Error setting up default objects: \(error)")
        }
    }
    
    func finishOnboarding() {
        guard let realm else { return }
        guard let company = realm.objects(CompanyEntity.self).first else { return }
        
        do {
            if let thawedCompany = company.thaw() {
                try realm.write {
                    thawedCompany.finishedOnboarding = true
                }
                isSetupComplete = true
            }
            
            if let thawedDepartment = realm.objects(DepartmentEntity.self).first, let item = realm.objects(ItemEntity.self).first {
                try realm.write {
                    thawedDepartment.items.append(item)
                }
                print("\(item.name) saved to \(thawedDepartment.name)")
            }
        } catch {
            print("Error finalizing onboarding: \(error)")
        }
    }
    
}

// MARK: - Onboarding View

struct OnboardingView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = OnboardingViewModel()
    @State private var path: NavigationPath = .init()
    @State private var isShowingLanding: Bool = false
    
    @ObservedResults(DepartmentEntity.self) var departments
    @ObservedResults(CompanyEntity.self) var companies
    @ObservedResults(ItemEntity.self) var items
    
    private var companyComplete: Bool {
        guard let company = companies.first else { return false }
        return !company.name.isEmpty
    }
    
    private var departmentComplete: Bool {
        guard let dept = departments.first else { return false }
        return !dept.name.isEmpty
    }
    
    private var itemComplete: Bool {
        guard let item = items.first else { return false }
        return !item.name.isEmpty
    }
    
    private var steps: [OnboardingStepModel] {[
        .init(condition: companyComplete,
              title: "Add your company info",
              description: "This will be used when calculating and displaying your sales.",
              destination: .company,
              isEnabled: true),
        
            .init(condition: departmentComplete,
                  title: "Add a department",
                  description: "Your items will be grouped into departments.",
                  destination: .department(DepartmentEntity()),
                  isEnabled: true),
        
            .init(condition: itemComplete,
                  title: "Add an item",
                  description: "You will be able to select items to add to the cart.",
                  destination: .item(ItemEntity()),
                  isEnabled: departmentComplete)
    ]
    }
    
    var body: some View {
        NavigationStack(path: $path) {
            FormX(title: "Setup") {
                VStack(spacing: 16) {
                    ForEach(steps) { step in
                        OnboardingStepRow(step: step) {
                            path.append(step.destination)
                        }
                        .opacity(step.isEnabled ? 1.0 : 0.5)
                        .disabled(!step.isEnabled)
                        
                        if step != steps.last {
                            Divider()
                        }
                    }
                } //: VStack
            } //: Form X
            .overlay(alignment: .bottom) {
                Button {
                    viewModel.finishOnboarding()
                    dismiss()
                } label: {
                    Text("Get Started")
                        .frame(maxWidth: 540, maxHeight: 32, alignment: .center)
                        .font(.headline)
                }
                .buttonStyle(.borderedProminent)
                .padding()
                .disabled(!(companyComplete && departmentComplete && itemComplete))
            }
            .navigationDestination(for: LSXDisplay.self) { view in
                destinationView(for: view)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("Done", action: { path.removeLast() })
                        }
                    }
            }
        } //: Navigation Stack
        .task {
            viewModel.setupDefaultObjects()
        }
        .onAppear {
            // Don't show landing if they've already begun onboarding
            if companyComplete || departmentComplete || itemComplete { return }
            isShowingLanding = true
        }
        .fullScreenCover(isPresented: $isShowingLanding) {
            LandingView()
        }
    }
    
    @ViewBuilder private func destinationView(for display: LSXDisplay) -> some View {
        switch display {
        case .company:
            CompanyDetailView(company: companies.first ?? CompanyEntity())
            
        case .department:
            DepartmentDetailView(department: departments.first ?? DepartmentEntity())
            
        case .item:
            ItemDetailView(item: items.first ?? ItemEntity())
            
        default: Color.clear
        }
    }
}

// MARK: - Onboarding Step View
struct OnboardingStepRow: View {
    let step: OnboardingStepModel
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
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
            .background(Color.bg100.opacity(0.001)) // Creates larger 'tappable' area
        }
        .buttonStyle(.plain)
    }
}
