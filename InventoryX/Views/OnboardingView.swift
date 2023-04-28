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
    private let lastPageInt: Int
    @Published var currentOnboardingState: OnboardingState = .start
    
    @Published var currentUser: UserEntity?
    
    //Categories
    @Published var tempCategories: [CategoryEntity] = []
    @Published var newCategoryName: String = ""
    @Published var newCategoryThreshold: Int = 10
    
    //Profile
    @Published var newProfileName: String = ""
    @Published var newProfileEmail: String = ""
    @Published var adminPasscode: String = ""
    @Published var isPasscodeProtected: Bool = false
    @Published var isShowingPasscodePad: Bool = false
    
    enum OnboardingState: Int, CaseIterable {
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
        
//        func next() {
//            let currentIndex = self.rawValue
//            let newDisplay = OnboardingState.init(rawValue: currentIndex + 1)
//            self = newDisplay
//        }
    }
    
    init() {
        var pageInt: Int = 0
        for navState in OnboardingState.allCases {
            let pageNum = navState.rawValue
            if pageNum > pageInt {
                pageInt = pageNum
            }
        }
        lastPageInt = pageInt
    }
    
    func nextTapped() {
        print("Next tapped")
        switch currentOnboardingState {
        case .start:
            break
        case .categoryNames:
            print("Save and Continue called")
            saveAndContinue()
        case .profileSetup:
            print("Save admin called")
            saveAdmin()
        }
        
        guard navCounter != lastPageInt else {
            print("Error 1")
            return
            
        }
        print("Nav Counter: \(navCounter) -> \(navCounter + 1)")
        navCounter += 1
        
        guard let newState = OnboardingState(rawValue: navCounter) else {
            print("Error setting new state")
            return
        }
        currentOnboardingState = newState
        print("New State set to \(newState)")
    }
    
    func saveAndContinue() {
        if self.newCategoryName != "" {
            addTempCategory()
        }
        
        tempCategories.forEach { category in
            saveCategory(category)
        }
    }
    
    // MARK: - CATEGORY FUNCTIONS
    func addTempCategory() {
        for category in tempCategories {
            if category.name == newCategoryName {
                print("Category already exists")
                return
            }
        }
        
        let newCategory = CategoryEntity(name: newCategoryName, restockNum: newCategoryThreshold)
        tempCategories.append(newCategory)
        newCategoryName = ""
        newCategoryThreshold = 10
    }
    
    func saveCategory(_ category: CategoryEntity) {
        do {
            let realm = try Realm()
            try realm.write ({
                realm.add(category)
            })
        } catch {
            AlertManager.shared.showError(title: "Error Saving", message: "\(error.localizedDescription)")
            print("Error saving category to Realm: \(error.localizedDescription)")
        }
    }
    
    func removeTempCategory(_ category: CategoryEntity) {
            guard let index = tempCategories.firstIndex(of: category) else {
                print("Error deleting category")
                return
            }
            tempCategories.remove(at: index)
        }
    
    // MARK: - USER FUNCTIONS
    func saveAdmin() {
        guard newProfileName.isNotEmpty else { return }
        let name: String = newProfileName
        var email: String?
        var passcode: String?
        
        if newProfileEmail.isNotEmpty {
            email = newProfileEmail
        }
        
        if isPasscodeProtected && adminPasscode.isNotEmpty {
            passcode = adminPasscode
        }
        
        let newUser = UserEntity()
        newUser.profileName = name
        newUser.email = email
        
        if let passcode = passcode {
            newUser.passcode = passcode
        }
        
        newUser.role = .admin
        
        do {
            let realm = try Realm()
            try realm.write ({
                realm.add(newUser)
            })
            self.currentUser = newUser
        } catch {
            print("Error saving category to Realm: \(error.localizedDescription)")
            return
        }
    }
    
    
}

// MARK: - VIEW

struct OnboardingView: View {
    @EnvironmentObject var userManager: UserManager
    @StateObject var vm: OnboardingViewModel = OnboardingViewModel()
    @StateObject var alertManager: AlertManager = AlertManager.shared
    @ObservedResults(CategoryEntity.self) var categories
    
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
        .alert(isPresented: $alertManager.isShowing) {
            alertManager.alert
        }
        .onChange(of: vm.currentUser) { newUser in
            guard let newUser = newUser else { return }
            userManager.loginUser(newUser)
        }
    } //: Body
    
    // MARK: - WELCOME PAGE
    private var welcomePage: some View {
        VStack {
            Text("Inventory X")
                .modifier(TextMod(.largeTitle, .bold))
            
            Spacer()
            
            continueButton
        } //: VStack
    } //: Welcome Page
    
    // MARK: - ADD CATEGORIES
    private var categoriesView: some View {
        GeometryReader { geo in
            HStack {
                VStack(spacing: 16) {
                    categoryNameSection
                    
                    categoryRestockSection
                        .padding(.vertical)
                    
                    Button {
                        vm.addTempCategory()
                    } label: {
                        Text("Add Category")
                            .modifier(TextMod(.title3, .semibold, .black))
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        
                        Image(systemName: "plus")
                            .modifier(TextMod(.title3, .bold))
                    }
                    .frame(maxWidth: 180, maxHeight: 10)
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(primaryColor, lineWidth: 4))
                    
                    Spacer()
                } //: VStack
                .frame(width: geo.size.width / 3)
                .padding(.vertical)
                
                Divider()
                
                if vm.tempCategories.isEmpty {
                    PlaceholderView(text: "Add A Category")
                } else {
                    VStack(spacing: 25) {
                        Text("Current Categories:")
                            .modifier(TextMod(.title2, .bold))
                        
                        ScrollView(.vertical, showsIndicators: false) {
                            ForEach(vm.tempCategories, id: \.self) { category in
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
            SectionHeader(section: .addCategory)
            
            AnimatedTextField(boundTo: $vm.newCategoryName, placeholder: "Category Name")
                .autocapitalization(UITextAutocapitalizationType.words)
                .padding(.vertical)
        } //: VStack
    } //: Category Name Section
    
    private var categoryRestockSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            SectionHeader(section: .restockThreshold)
            
            QuantitySelector(selectedQuantity: $vm.newCategoryThreshold)
                .frame(maxWidth: .infinity)
                .padding(.vertical)
        } //: VStack
    } //: Category Restock Section
    
    // MARK: - PROFILE
    private var profileSetup: some View {
        GeometryReader { geo in
            VStack {
                VStack(spacing: 32) {
                    VStack(spacing: 24) {
                        SectionHeader(section: .adminSetup)
                        
                        AnimatedTextField(boundTo: $vm.newProfileName, placeholder: "Profile Name")
                            .autocapitalization(UITextAutocapitalizationType.words)
                    }
                    
                    VStack {
                        SectionHeader(section: .email)
                        
                        AnimatedTextField(boundTo: $vm.newProfileEmail, placeholder: "Email")
                            .autocapitalization(UITextAutocapitalizationType.words)
                            .padding(.vertical)
                    }
                    
                    Toggle(isOn: $vm.isPasscodeProtected) {
                        Text("Password Protected")
                    }
                    .onChange(of: vm.isPasscodeProtected) { isProtected in
                        if isProtected {
                            vm.isShowingPasscodePad.toggle()
                        }
                    }
                } //: VStack
                
                Spacer()
                
                continueButton
            } //: VStack
            .frame(width: geo.size.width / 3)
            .padding(.vertical)
            .frame(maxWidth: .infinity)
            .sheet(isPresented: $vm.isShowingPasscodePad) {
                PasscodePad(padState: .createPasscode, completion: { confirmedPasscode in
                    vm.adminPasscode = confirmedPasscode
                    vm.isShowingPasscodePad.toggle()
                })
            }
        } //: Geometry Reader
    } //: Profile Setup
    
    
    private var continueButton: some View {
        Button(action: {
            vm.nextTapped()
        }, label: {
            Text(vm.currentOnboardingState.buttonText)
        })
        .modifier(RoundedButtonMod())
        .padding(.bottom)
    } //: Continue Button
    
    struct PlaceholderView: View {
        let text: String
        
        var body: some View {
            VStack(spacing: 16) {
                Image(systemName: "arrowshape.turn.up.left.2.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: 150, alignment: .leading)
                    .padding()
                
                Spacer()
                    .frame(height: 30)
                
                Text(text)
                    .modifier(TextMod(.largeTitle, .bold))
                
                Spacer()
            } //: VStack
            .frame(maxWidth: 600, maxHeight: .infinity)
            .padding()
            .foregroundColor(primaryColor)
            .opacity(0.5)
        }
    }
    
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
//        OnboardingView(isOnboarding: $onboarding)
        OnboardingView()
            .modifier(PreviewMod())
    }
}
