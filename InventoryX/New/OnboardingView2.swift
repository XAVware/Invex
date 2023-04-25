//
//  OnboardingView2.swift
//  InventoryX
//
//  Created by Smetana, Ryan on 4/24/23.
//

import SwiftUI
import RealmSwift

@MainActor class OnboardingViewModel: ObservableObject {
    var navCounter: Int = 0
    @Published var currentOnboardingState: OnboardingStates = .categoryNames
    @Published var categories: [CategoryEntity] = []
    @Published var newCategoryName: String = ""
    @Published var adminPasscode: String = ""
    
    @Published var isOnboarding: Bool = true
    
    private let lastPageInt: Int
    
    enum OnboardingStates: Int, CaseIterable {
        case start = 0
        case categoryNames = 1
        case categoryRestock = 2
        case adminPasscode = 3
        
        var buttonText: String {
            switch self {
            case .start:
                return "Get Started"
            case .categoryNames:
                return "Save & Continue"
            case .categoryRestock:
                return "Save & Continue"
            case .adminPasscode:
                return "Finish"
            }
        }
        
    }
    
    init() {
        var pageInt: Int = 0
        for navState in OnboardingStates.allCases {
            let pageNum = navState.rawValue
            if pageNum > pageInt {
                pageInt = pageNum
            }
        }
        lastPageInt = pageInt
    }
    
    func addTempCategory() {
        for category in categories {
            if category.name == newCategoryName {
                print("category already exists")
                return
            }
        }
        
        let newCategory: CategoryEntity = CategoryEntity(name: newCategoryName)
        self.categories.append(newCategory)
        self.newCategoryName = ""
        
    }
    
    func saveAndContinue() {
        if self.newCategoryName != "" {
            addTempCategory()
        }
    }
    
    func nextTapped() {
        guard navCounter != lastPageInt else {
            isOnboarding = false
            return
        }
        
        switch currentOnboardingState {
        case .start:
            break
            
        case .categoryNames:
            saveAndContinue()
            
        case .categoryRestock:
            // Save Restock Numbers
            saveAndContinue()
            
        case .adminPasscode:
            // Save admin credentials and finish onboarding
            break
        }
        
        navCounter += 1
        
        guard let newState = OnboardingStates(rawValue: navCounter) else {
            print("Error setting new state")
            return
        }
        currentOnboardingState = newState
    }
    
    func savePasscodeAndProceed() {
        self.isOnboarding = false
    }
    
    func saveCategories() {
        let realm = try! Realm()
        for category in categories {
            try! realm.write ({
                realm.add(category)
            })
        }
    }
    
    func saveAdmin() {
        
    }
    
    func removeTempCategory(_ category: CategoryEntity) {
        guard let index = categories.firstIndex(of: category) else {
            print("Error deleting category")
            return
        }
        categories.remove(at: index)
    }
}

struct OnboardingView2: View {
    @StateObject var vm: OnboardingViewModel = OnboardingViewModel()
    @Binding var isOnboarding: Bool
    
    var body: some View {
        VStack {
            switch(vm.currentOnboardingState) {
            case .start:
                welcomePage
                
            case .categoryNames:
                categoriesView
                
            case .categoryRestock:
                categoryRestockView
                
            case .adminPasscode:
                adminSetup
            } //: Switch
        } //: VStack
        .padding()
        .onChange(of: vm.isOnboarding) { newValue in
            self.isOnboarding = newValue
        }
    }
    
    private var adminSetup: some View {
        VStack {
            Text("Finally, enter an admin passcode")
                .modifier(TextMod(.title, .bold))
                .padding()
            
            Text("This passcode should be used by administrators to access features such as inventory adjustments")
                .modifier(TextMod(.callout))
                .multilineTextAlignment(.center)
            
            Spacer()
            
                            
            PasscodePad(padState: .setPasscode, completion: { vm.savePasscodeAndProceed() })
                .padding()
        } //: VStack
    } //: Admin Setup
    
    private var categoriesView: some View {
        GeometryReader { geo in
            HStack {
                VStack(spacing: 8) {
                    Text("Add Categories")
                        .modifier(TextMod(.title, .bold))
                        .padding(.bottom)
                    
                    Text("Your inventory will be displayed based on their category.")
                        .modifier(TextMod(.callout, .regular, .black))
                        .multilineTextAlignment(.center)
                                        
                    AnimatedTextField(boundTo: $vm.newCategoryName, placeholder: "Category Name")
                        .autocapitalization(UITextAutocapitalizationType.words)
                        .padding(.vertical)
                    
                    Button(action: {
                        vm.addTempCategory()
                    }, label: {
                        Text("+ Add Category")
                    })
                    .foregroundColor(primaryColor)
                    .padding()
                    
                    Spacer()
                } //: VStack
                .frame(width: geo.size.width / 3)
                
                Divider()
                
                VStack(spacing: 25) {
                    Text("Current Categories:")
                        .modifier(TextMod(.title2, .bold))
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack {
                            ForEach(vm.categories, id: \.self) { category in
                                HStack {
                                    Text(category.name)
                                    
                                    Spacer()
                                    
                                    Button {
                                        vm.removeTempCategory(category)
                                    } label: {
                                        Image(systemName: "trash")
                                            .foregroundColor(.red)
                                    }
                                }//: HStack
                                .frame(height: 40)
                                
                                Divider().opacity(0.5)
                            }//: ForEach
                            
                        }//: VStack
                        .frame(maxWidth: .infinity)
                    } //: Scroll
                    
                    continueButton
                } //: VStack - Current Categories
            } //: HStack
        } //: Geometry Reader

        
    } //: Categories View
    
    private var categoryRestockView: some View {
        VStack {
            Text("Next, Select Your Restock Point")
                .modifier(TextMod(.title, .bold))
                .padding()
            
            Text("Enter the restock point for each category. ConcessionTracker will alert you when an item in the corresponding category needs to be restocked.")
                .modifier(TextMod(.callout))
            
            Spacer().frame(height: 50)
            
            
            Divider()
            
            VStack(spacing: 25) {
                Text("Your Categories:")
                    .modifier(TextMod(.title2, .bold))
                    .opacity(0.8)
                
                ScrollView(.vertical, showsIndicators: false, content: {
                    VStack {
                        ForEach(vm.categories, id: \.self) { category in
                            HStack {
                                Text(category.name)
                                
                                Spacer()
                                
                                HStack(spacing: 0) {
                                    Button(action: {
                                        guard category.restockNumber >= 0 else {
                                            return
                                        }
                                        category.restockNumber -= 1
                                    }) {
                                        Image(systemName: "minus.circle.fill")
                                            .opacity(0.7)
                                    } //: Button
                                    
                                    Text("\(category.restockNumber)")
                                        .frame(width: 40)
                                        .multilineTextAlignment(.center)
                                    
                                    
                                    Button(action: {
                                        category.restockNumber += 1
                                    }) {
                                        Image(systemName: "plus.circle.fill")
                                            .opacity(0.7)
                                    } //: Button
                                }//: HStack
                                .foregroundColor(.black)
                                
                            }//: HStack
                            .frame(height: 40)
                            
                            Divider().opacity(0.5)
                        }//: ForEach
                        
                    }//: VStack
                    .frame(maxWidth: 400)
                })
            } //: VStack - Current Categories
            
            continueButton
            
        }
    } //: Category Restock View
    
    private var continueButton: some View {
        Button(action: {
            vm.nextTapped()
        }, label: {
            Text(vm.currentOnboardingState.buttonText)
        })
        .modifier(RoundedButtonMod())
    } //: Continue Button
    
    private var welcomePage: some View {
        VStack {
            Text("Inventory X")
                .modifier(TextMod(.largeTitle, .bold))
            
            Spacer()
            
            continueButton
        } //: VStack
    } //: Welcome Page
    
}

struct OnboardingView2_Previews: PreviewProvider {
    @State static var onboarding: Bool = true
    static var previews: some View {
        OnboardingView2(isOnboarding: $onboarding)
//            .previewDevice(PreviewDevice(rawValue: "iPad Pro (11-inch) (4th generation)"))
            .modifier(PreviewMod())
    }
}
