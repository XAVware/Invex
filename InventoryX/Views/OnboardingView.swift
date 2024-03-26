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
    
//    func saveCompany(name: String, tax: String) {
//        guard let taxRate = Double(tax) else {
//            print("Please enter a valid tax rate percentage.")
//            return
//        }
//        
//        let company = CompanyEntity(name: name, taxRate: taxRate)
//        do {
//            let realm = try Realm()
//            try realm.write {
//                realm.add(company)
//            }
//            currentDisplay = .setPasscode
//        } catch {
//            print("Error saving company: \(error.localizedDescription)")
//        }
//    }

}

struct OnboardingView: View {
    @Environment(\.dismiss) var dismiss
    @State var currentDisplay: OnboardingState = .start
    
//    @State var companyName: String = ""
//    @State var taxRate: String = ""
    
//    @State var passcodeHash: String = ""
    
    var body: some View {
        
        VStack {
            switch currentDisplay {
            case .start:
                VStack(spacing: 24) {
                    LogoView()
                        .scaleEffect(1.0)
                        .padding(.top)
                    
                    Text("Welcome to Invex! Let's get you set up.")
                        .font(.largeTitle)
                        .padding(.vertical)
                    
                    CompanyDetailView(company: nil, showTitles: false) {
                        currentDisplay = .setPasscode
                    }
                    
                } //: VStack
                .frame(maxWidth: 480)
                
            case .setPasscode:
                VStack(spacing: 24) {
                    Text("Create your admin passcode")
                        .font(.largeTitle)
                        .padding(.vertical)
                    
                    ChangePasscodeView(passHash: nil) {
                        currentDisplay = .department
                    }
                    
                    Button {
                        currentDisplay = .start
                    } label: {
                        Image(systemName: "chevron.left")
                        Text("Back")
                            .underline()
                    }
                    
                    
                } //: VStack
                .frame(maxWidth: 480)
                
            case .department:
                VStack(spacing: 24) {
                    DepartmentDetailView(department: nil, showTitles: false) {
                        currentDisplay = .item
                    }
                    
                    Button {
                        currentDisplay = .setPasscode
                    } label: {
                        Image(systemName: "chevron.left")
                        Text("Back")
                            .underline()
                    }
                } //: VStack
                
            case .item:
                VStack(spacing: 24) {
                    AddItemView(item: nil) {
                        dismiss()
                    }
                    
                    Button {
                        currentDisplay = .department
                    } label: {
                        Image(systemName: "chevron.left")
                        Text("Back")
                            .underline()
                    }
                } //: VStack
            } //: Switch
            
            
        } //: VStack
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("Purple050").opacity(0.5))
        
        
    } //: Body
    
    
}

#Preview {
    OnboardingView()
        .environment(\.realm, DepartmentEntity.previewRealm)
}
