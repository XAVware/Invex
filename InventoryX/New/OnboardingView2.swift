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
    @Published var currentOnboardingState: OnboardingStates = .profileSetup
    @Published var categories: [CategoryEntity] = []
    @Published var newCategoryName: String = ""
    @Published var newCategoryThreshold: Int = 10
    @Published var adminPasscode: String = ""
    
    @Published var isOnboarding: Bool = true
    
    @Published var newProfileName: String = ""
    @Published var newProfileEmail: String = ""
    
    private let lastPageInt: Int
    
    enum OnboardingStates: Int, CaseIterable {
        case start = 0
        case categoryNames = 1
        case profileSetup = 2
        
        var buttonText: String {
            switch self {
            case .start:
                return "Get Started"
            case .categoryNames:
                return "Save & Continue"
            case .profileSetup:
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
                print("Category already exists")
                return
            }
        }
        
        let newCategory = CategoryEntity(name: newCategoryName, restockNum: newCategoryThreshold)
        categories.append(newCategory)
        newCategoryName = ""
        newCategoryThreshold = 10
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
            
        case .profileSetup:
            // Save admin credentials and finish onboarding
            isOnboarding = false
        }
        
        navCounter += 1
        
        guard let newState = OnboardingStates(rawValue: navCounter) else {
            print("Error setting new state")
            return
        }
        currentOnboardingState = newState
    }
    
    func saveAndContinue() {
        if self.newCategoryName != "" {
            addTempCategory()
        }
        
        categories.forEach { category in
            saveCategory(category)
        }
    }
    
    func savePasscodeAndProceed() {
        self.isOnboarding = false
    }
    
    func saveCategory(_ category: CategoryEntity) {
        do {
            let realm = try Realm()
            try realm.write ({
                realm.add(category)
            })
        } catch {
            print("Error saving category to Realm: \(error.localizedDescription)")
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
                
            case .profileSetup:
                profileSetup
            } //: Switch
        } //: VStack
        .padding()
        .onChange(of: vm.isOnboarding) { newValue in
            isOnboarding = newValue
        }
    }
    
    private var categoriesView: some View {
        GeometryReader { geo in
            HStack {
                VStack(spacing: 16) {
                    categoryNameSection
                    
                    categoryRestockSection
                        .padding(.vertical)
                    
                    Button(action: {
                        vm.addTempCategory()
                    }, label: {
                        Text("+ Add Category")
                    })
                    .foregroundColor(primaryColor)
                    
                    Spacer()
                } //: VStack
                .frame(width: geo.size.width / 3)
                .padding(.vertical)
                
                Divider()
                
                if vm.categories.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "arrowshape.turn.up.left.2.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity, maxHeight: geo.size.width * 0.12, alignment: .leading)
                            .padding()
                        
                        Spacer()
                            .frame(height: 30)
                        
                        Text("Add A Category")
                            .modifier(TextMod(.largeTitle, .bold))
                        
                        Spacer()
                    } //: VStack
                    .frame(maxWidth: 600, maxHeight: .infinity)
                    .padding()
                    .foregroundColor(primaryColor)
                    .opacity(0.5)
                } else {
                    VStack(spacing: 25) {
                        Text("Current Categories:")
                            .modifier(TextMod(.title2, .bold))
                        
                        ScrollView(.vertical, showsIndicators: false) {
                            ForEach(vm.categories, id: \.self) { category in
                                CategoryRow(category: category, parent: vm)
                                    .frame(height: 40)
                                
                                Divider().opacity(0.5)
                            }//: ForEach
                        }//: Scroll
                        .frame(maxWidth: .infinity)
                        continueButton
                    } //: VStack
                } //: If-Else
                
            } //: HStack
        } //: Geometry Reader
    } //: Categories View
    
    private var categoryNameSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Add A Category")
                .modifier(TextMod(.title, .bold, .black))
            
            Text("Your inventory will be displayed based on their category.")
                .modifier(TextMod(.footnote, .semibold, .gray))
                .multilineTextAlignment(.leading)
                                
            AnimatedTextField(boundTo: $vm.newCategoryName, placeholder: "Category Name")
                .autocapitalization(UITextAutocapitalizationType.words)
                .padding(.vertical)
        } //: VStack
    } //: Category Name Section
    
    private var categoryRestockSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Restock Threshold")
                .modifier(TextMod(.title, .bold, .black))
            
            Text("If an item reaches its category's restock threshold, InventoryX will alert you.")
                .modifier(TextMod(.footnote, .semibold, .gray))
                .multilineTextAlignment(.leading)
            
            QuantitySelector(selectedQuantity: $vm.newCategoryThreshold)
                .frame(maxWidth: .infinity)
                .padding(.vertical)
        } //: VStack
    } //: Category Restock Section
    
    private var profileSetup: some View {
        GeometryReader { geo in
            HStack {
                VStack(spacing: 16) {
                    profileNameSection
                    
//                    profileEmailSection
//                        .padding(.vertical)
                    
                    Button(action: {
                        vm.addTempCategory()
                    }, label: {
                        Text("+ Add Category")
                    })
                    .foregroundColor(primaryColor)
                    
                    Spacer()
                } //: VStack
                .frame(width: geo.size.width / 3)
                .padding(.vertical)
                
                Divider()
                
                if vm.categories.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "arrowshape.turn.up.left.2.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity, maxHeight: geo.size.width * 0.12, alignment: .leading)
                            .padding()
                        
                        Spacer()
                            .frame(height: 30)
                        
                        Text("Add A Profile")
                            .modifier(TextMod(.largeTitle, .bold))
                        
                        Spacer()
                    } //: VStack
                    .frame(maxWidth: 600, maxHeight: .infinity)
                    .padding()
                    .foregroundColor(primaryColor)
                    .opacity(0.5)
                } else {
                    VStack(spacing: 25) {
                        Text("Current Categories:")
                            .modifier(TextMod(.title2, .bold))
                        
                        ScrollView(.vertical, showsIndicators: false) {
                            ForEach(vm.categories, id: \.self) { category in
                                CategoryRow(category: category, parent: vm)
                                    .frame(height: 40)
                                
                                Divider().opacity(0.5)
                            }//: ForEach
                        }//: Scroll
                        .frame(maxWidth: .infinity)
                        continueButton
                    } //: VStack
                } //: If-Else
                
            } //: HStack
        } //: Geometry Reader
    } //: Profile Setup
    
    private var profileNameSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Add A Profile")
                .modifier(TextMod(.title, .bold, .black))
            
            Text("Multiple profiles allow admins to control what access other user's have. Including an email will allow you to setup InventoryX to email you alerts with restock information.")
                .modifier(TextMod(.footnote, .semibold, .gray))
                .multilineTextAlignment(.leading)
                                
            AnimatedTextField(boundTo: $vm.newProfileName, placeholder: "Profile Name")
                .autocapitalization(UITextAutocapitalizationType.words)
                .padding(.vertical)
            
            AnimatedTextField(boundTo: $vm.newProfileEmail, placeholder: "Email")
                .autocapitalization(UITextAutocapitalizationType.words)
        } //: VStack
    } //: Profile Name Section
    
    private var adminSetup: some View {
        VStack {
            Text("Create An Admin Passcode")
                .modifier(TextMod(.title, .bold, .black))
            
            Text("This passcode should be used by administrators to access features such as inventory adjustments")
                .modifier(TextMod(.footnote, .semibold, .gray))
                .multilineTextAlignment(.leading)
            
            Spacer()
            
            PasscodePad(padState: .setPasscode, completion: { vm.savePasscodeAndProceed() })
                .padding()
            
            Spacer()
            
            continueButton
        } //: VStack
    } //: Admin Setup
    
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
    
    struct CategoryRow: View {
        let category: CategoryEntity
        let parent: OnboardingViewModel
        
        var body: some View {
            HStack {
                Text(category.name)
                
                Spacer()
                
                Button {
                    parent.removeTempCategory(category)
                } label: {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                }
            }//: HStack
        }
    }
}

struct OnboardingView2_Previews: PreviewProvider {
    @State static var onboarding: Bool = true
    static var previews: some View {
        OnboardingView2(isOnboarding: $onboarding)
//            .previewDevice(PreviewDevice(rawValue: "iPad Pro (11-inch) (4th generation)"))
            .modifier(PreviewMod())
    }
}
