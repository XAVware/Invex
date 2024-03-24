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

struct OnboardingView: View {
    @Environment(\.dismiss) var dismiss
//    @StateObject var vm: OnboardingViewModel = OnboardingViewModel()
    
    @State var currentDisplay: OnboardingState = .start
    
    @State var companyName: String = ""
    @State var taxRate: String = ""
    
    @State var passcodeHash: String = ""
    
    var body: some View {
        
        VStack {
            switch(currentDisplay) {
            case .start:
                VStack(spacing: 24) {
                    LogoView()
                        .scaleEffect(2.0)
                        .padding(.top)
                    
                    Text("Welcome to Invex! Let's get you set up.")
                        .font(.largeTitle)
                        .padding(.vertical)
                    
                    
                    VStack(alignment: .leading, spacing: 16) {
                        InputFieldLabel(title: "Business Name:", subtitle: nil)
                            .frame(maxWidth: 420, alignment: .leading)
                        
                        TextField("Company name", text: $companyName)
                            .modifier(ThemeFieldMod())
                    } //: VStack - Department Name
                    
                    Divider()
                    
                    HStack(spacing: 16) {
                        InputFieldLabel(title: "Tax Rate:", subtitle: "If you want us to calculate the tax on your sales, enter a tax rate here.")
                        
                        Spacer()
                        
                        TextField("X.xx", text: $taxRate)
                            .frame(maxWidth: 72, alignment: .center)
                            .modifier(ThemeFieldMod(overlayText: "%", overlaySide: .trailing))
                    } //: HStack - Markup
                    .frame(maxWidth: 720)
                    
                    Spacer()
                    
                    Button {
                        // Save company info
                        currentDisplay = .setPasscode
                    } label: {
                        Text("Continue")
                    }
                    .modifier(PrimaryButtonMod())
                    .padding(.bottom)
                    
                } //: VStack
                .frame(maxWidth: 480)
                
            case .setPasscode:
                VStack(alignment: .center) {
                    VStack(spacing: 24) {
                        Text("Enter Passcode")
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
                            currentDisplay = .department
                        }
                    }
                    .padding(.vertical)
                    .frame(maxWidth: 360, maxHeight: 540, alignment: .center)
                    
                    
                } //: VStack
                
            case .department:
                AddDepartmentView(isOnboarding: true) {
                    currentDisplay = .item
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

struct OnboardingView_Previews: PreviewProvider {
    @State static var onboarding: Bool = true
    static var previews: some View {
        OnboardingView()
            .previewDevice(PreviewDevice(rawValue: "iPad Pro (11-inch) (4th generation)"))
            .previewInterfaceOrientation(.landscapeLeft)
            .environment(\.realm, DepartmentEntity.previewRealm)
    }
}
