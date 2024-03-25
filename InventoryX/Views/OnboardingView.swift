//
//  OnboardingView.swift
//  InventoryX
//
//  Created by Smetana, Ryan on 4/24/23.
//

import SwiftUI
import RealmSwift

//@MainActor class OnboardingViewModel: ObservableObject {
//    var navCounter: Int = 0
//    private let lastPageInt: Int
//    @Published var currentOnboardingState: OnboardingState = .start
//    
//    enum OnboardingState: Int, CaseIterable {
//        case start = 0
//        case setPasscode = 1
//        case department = 2
//        case item = 3
//    }
//    
//    init() {
//        // Iterate through OnboardingState enum to figure out how many pages there are. This allows the overall workflow (welcome page, categories, admin) to be reorganized or edited via integer value in enum.
//        var pageInt: Int = 0
//        for navState in OnboardingState.allCases {
//            let pageNum = navState.rawValue
//            if pageNum > pageInt {
//                pageInt = pageNum
//            }
//        }
//        lastPageInt = pageInt
//    }
//    
//    func nextTapped() {
//
//    }
//    
//    
//}

enum OnboardingState: Int {
    case start
    case setPasscode
    case department
    case item
}

@MainActor class OnboardingViewModel: ObservableObject {
    @Published var currentDisplay: OnboardingState = .start
    
    func saveCompany(name: String, tax: String) {
        guard let taxRate = Double(tax) else {
            print("Please enter a valid tax rate percentage.")
            return
        }
        
        let company = CompanyEntity(name: name, taxRate: taxRate)
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(company)
            }
            currentDisplay = .setPasscode
        } catch {
            print("Error saving company: \(error.localizedDescription)")
        }
    }
    
    func savePasscode(passcodeHash: String) {
        
    }
}

struct OnboardingView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var vm: OnboardingViewModel = OnboardingViewModel()
    
    
    
    @State var companyName: String = ""
    @State var taxRate: String = ""
    
    @State var passcodeHash: String = ""
    
    var body: some View {
        
        VStack {
            switch vm.currentDisplay {
            case .start:
                VStack(spacing: 24) {
                    LogoView()
                        .scaleEffect(1.0)
                        .padding(.top)
                    
                    Text("Welcome to Invex! Let's get you set up.")
                        .font(.largeTitle)
                        .padding(.vertical)
                    
                    CompanyDetailView(company: nil, showTitles: false) {
                        vm.currentDisplay = .setPasscode
                    }
                    
                } //: VStack
                .frame(maxWidth: 480)
                
            case .setPasscode:
                VStack(alignment: .center) {
                    VStack(spacing: 24) {
                        Text(passcodeHash.isEmpty ? "Enter Passcode" : "Re-enter passcode")
                            .font(.largeTitle)
                            .fontWeight(.semibold)
                        
                        Text("Enter a 4-digit passcode to be used to unlock the app.")
                            .font(.subheadline)
                            .multilineTextAlignment(.center)
                    } //: VStack
                    
                    PasscodeView() { hash in
                        if passcodeHash.isEmpty {
                            print("Setting first passcode to: \(hash)")
                            passcodeHash = hash
                        } else {
                            guard passcodeHash == hash else {
                                passcodeHash = ""
                                return
                            }
                            
                            print("Passcodes match")
                            
                            AuthService.shared.savePasscode(hash: passcodeHash)
                            vm.currentDisplay = .department
                        }
                    }
                    .padding(.vertical)
                    .frame(maxWidth: 360, maxHeight: 540, alignment: .center)
                    
                    
                } //: VStack
                
            case .department:
                AddDepartmentView(isOnboarding: true) {
                    vm.currentDisplay = .item
                }
                
            case .item:
                AddItemView(selectedItem: nil, isOnboarding: true) {
                    dismiss()
                }
                
            } //: Switch
            
            
        } //: VStack
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("Purple050").opacity(0.5))
        
    } //: Body
    
    
}

#Preview {
    OnboardingView()
//    CompanyDetailView()
        .environment(\.realm, DepartmentEntity.previewRealm)
}



