//
//  OnboardingView.swift
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
    
    //    @Published var currentUser: UserEntity?
    
    //Categories
    @Published var tempCategories: [CategoryEntity] = []
    @Published var newCategoryName: String = ""
    @Published var thresholdString: String = "10"
    
    //Profile
    @Published var newProfileName: String = ""
    @Published var newProfileEmail: String = ""
    
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
        // Iterate through OnboardingState enum to figure out how many pages there are. This allows the overall workflow (welcome page, categories, admin) to be reorganized or edited via integer value in enum.
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
        guard navCounter != lastPageInt else {
            finishOnboarding()
            return
            
        }
        
        switch currentOnboardingState {
        case .start:
            break
            
        case .categoryNames:
            if self.newCategoryName != "" {
                addTempCategory()
            }
            
        case .profileSetup:
            guard let _ = getAdmin() else {
                print("Saving user failed")
                return
            }
            //            saveUser(user)
        }
        
        navCounter += 1
        
        guard let newState = OnboardingState(rawValue: navCounter) else {
            print("Error setting new state")
            return
        }
        currentOnboardingState = newState
    }
    
    // MARK: - CATEGORY FUNCTIONS
    func addTempCategory() {
        guard let threshold = Int(thresholdString) else { return }
        for category in tempCategories {
            if category.name == newCategoryName { return }
        }
        
        let newCategory = CategoryEntity(name: newCategoryName, restockNum: threshold)
        tempCategories.append(newCategory)
        newCategoryName = ""
        thresholdString = "10"
    }
    
    func removeTempCategory(_ category: CategoryEntity) {
        guard let index = tempCategories.firstIndex(of: category) else { return }
        tempCategories.remove(at: index)
    }
    
    // MARK: - USER FUNCTIONS
    func getAdmin() -> UserEntity? {
        guard newProfileName.isNotEmpty else { return nil }
        let name: String = newProfileName
        var email: String?
        
        if newProfileEmail.isNotEmpty {
            email = newProfileEmail
        }
        
        let newUser = UserEntity()
        newUser.profileName = name
        newUser.email = email
        
        newUser.role = .admin
        
        return newUser
    }
    
    func finishOnboarding() {
        debugPrint("Finishing onboarding process...")
        guard let newUser = getAdmin() else { return }
        
        do {
            let realm = try Realm()
            try realm.write ({
                realm.add(tempCategories)
                realm.add(newUser)
            })
            UserManager.shared.loginUser(newUser)
            debugPrint("Categories and user saved")
        } catch {
//            AlertManager.shared.showError(title: "Error Saving", message: "\(error.localizedDescription)")
            print("Error saving category to Realm: \(error.localizedDescription)")
        }
    }
    
    
}

// MARK: - VIEW

struct OnboardingView: View {
//    @EnvironmentObject var userManager: UserManager
    @StateObject var vm: OnboardingViewModel = OnboardingViewModel()
    @StateObject var alertManager: AlertManager = AlertManager.shared
    @ObservedResults(CategoryEntity.self) var categories
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                primaryBackground
                    .edgesIgnoringSafeArea(.all)
                
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
                .frame(maxWidth: 0.75 * geo.size.width)
                .background(secondaryBackground)
                .cornerRadius(20)
                .padding()
                .alert(isPresented: $alertManager.isShowing) {
                    alertManager.alert
                }
            } //: ZStack
        }
    } //: Body
    
    // MARK: - WELCOME PAGE
    private var welcomePage: some View {
        VStack {
            LogoView()
                .scaleEffect(2.0)
                .padding(.top)
            
            Spacer()
            
            continueButton
        } //: VStack
    } //: Welcome Page
    
    // MARK: - ADD CATEGORIES
    private var categoriesView: some View {
        GeometryReader { geo in
            VStack(spacing: 16) {
                Text("Setup Categories")
                    .modifier(TextMod(.largeTitle, .bold, darkFgColor))
                
                HStack(spacing: 8) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Category Name")
                            .modifier(TextMod(.title3, .bold, .black))
    
                        Text("Your inventory will be displayed based on their category. This should be a broad term that represents some of your items. I.e Food, Books, etc.")
                            .modifier(TextMod(.footnote, .thin, .black))
                            .multilineTextAlignment(.leading)
                            .frame(width: 0.4 * geo.size.width, alignment: .leading)
                    } //: VStack
                    .frame(width: 0.4 * geo.size.width)
                    
                    Spacer()
                    
                    AnimatedTextField(boundTo: $vm.newCategoryName, placeholder: "Category Name")
                        .autocapitalization(UITextAutocapitalizationType.words)
                        .frame(width: 0.4 * geo.size.width)
                } //: HStack
                .frame(maxWidth: .infinity)
                .padding(.vertical)
    
                HStack(spacing: 8) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Restock Threshold")
                            .modifier(TextMod(.title3, .bold, .black))
    
                        Text("If an item reaches its category's restock threshold, InventoryX will alert you.")
                            .modifier(TextMod(.footnote, .thin, .black))
                            .multilineTextAlignment(.leading)
                            .frame(width: 0.4 * geo.size.width, alignment: .leading)
                    } //: VStack
                    .frame(width: 0.4 * geo.size.width)
                    
                    Spacer()
                    
                    AnimatedTextField(boundTo: $vm.thresholdString, placeholder: "Threshold")
                        .autocapitalization(UITextAutocapitalizationType.words)
                        .frame(width: 0.4 * geo.size.width)
                } //: HStack
                .frame(maxWidth: .infinity)
                .padding(.vertical)
                                
                Button {
                    vm.addTempCategory()
                } label: {
                    HStack(spacing: 24) {
                        Text("Save and Add Another")
                        Image(systemName: "plus")
                    } //: HStack
                    .modifier(TextMod(.body, .regular, darkFgColor))
                    .frame(maxWidth: 0.35 * geo.size.width, maxHeight: 32)
                }
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(primaryBackground, lineWidth: 1))
                
                Spacer()
                
                if !vm.tempCategories.isEmpty {
                    VStack(spacing: 16) {
                        HStack {
                            Text("Category")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                                        
                            Text("Threshold")
                                .frame(maxWidth: .infinity, alignment: .center)
                            
                            Spacer()
                                .frame(maxWidth: .infinity)   .opacity(0.6)
                        } //: HStack
                        .modifier(TextMod(.callout, .semibold))
                            
                        ScrollView(.vertical, showsIndicators: false) {
                            ForEach(vm.tempCategories, id: \.self) { category in
                                HStack {
                                    Text(category.name)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                                                        
                                    Text("\(category.restockNumber)")
                                        .frame(maxWidth: .infinity, alignment: .center)
                                                                        
                                    Button {
                                        vm.removeTempCategory(category)
                                    } label: {
                                        Image(systemName: "trash")
                                            .foregroundColor(.red)
                                            .opacity(0.6)
                                    }
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                                }//: HStack
                                .modifier(TextMod(.footnote, .thin, .black))
                                
                                Divider().opacity(0.5)
                            }//: ForEach
                        }//: Scroll
                        
                        continueButton
                    } //: VStack
                    .frame(maxWidth: 0.5 * geo.size.width)
                }
            } //: VStack
            .padding()
            .frame(maxWidth: .infinity)
        } //: Geometry Reader
    } //: Categories View
    
    
    // MARK: - PROFILE
    private var profileSetup: some View {
        GeometryReader { geo in
            VStack {
                Text("Profile Setup")
                    .modifier(TextMod(.largeTitle, .bold, darkFgColor))
                
                VStack(spacing: 24) {
                    HStack {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Create Admin Profile")
                                .modifier(TextMod(.title3, .bold, .black))
                            
                            Text("Your admin profile will give you full access to the app. You can create other accounts later.")
                                .modifier(TextMod(.footnote, .thin, .black))
                                .multilineTextAlignment(.leading)
                        } //: VStack
                        .frame(width: 0.4 * geo.size.width)
                        
                        Spacer()
                        
                        AnimatedTextField(boundTo: $vm.newProfileName, placeholder: "Profile Name")
                            .autocapitalization(UITextAutocapitalizationType.words)
                            .frame(width: 0.4 * geo.size.width)
                    } //: HStack
                    
                    Divider().background(secondaryBackground)
                                        
                    HStack(spacing: 32) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Add An Email")
                                .modifier(TextMod(.title3, .bold, .black))
                                                        
                            Text("If you add an email you can receive email notifications when item inventory is low.")
                                .modifier(TextMod(.footnote, .thin, .black))
                                .multilineTextAlignment(.leading)
                        } //: VStack
                        .frame(width: 0.4 * geo.size.width)
                        
                        Spacer()
                        
                        AnimatedTextField(boundTo: $vm.newProfileEmail, placeholder: "Email")
                            .autocapitalization(UITextAutocapitalizationType.none)
                            .frame(width: 0.4 * geo.size.width)
                    } //: HStack
                    
                    Spacer()
                } //: VStack
                
                continueButton
            } //: VStack
            .frame(width: 0.9 * geo.size.width)
            .padding(.vertical)
            .frame(maxWidth: .infinity)
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
}

struct OnboardingView_Previews: PreviewProvider {
    @State static var onboarding: Bool = true
    static var previews: some View {
        OnboardingView()
            .modifier(PreviewMod())
    }
}
