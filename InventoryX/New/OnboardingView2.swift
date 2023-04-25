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
    @Published var newCategoryThreshold: Int = 10
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
                print("Category already exists")
                return
            }
        }
        
        let newCategory = CategoryEntity(name: newCategoryName, restockNum: newCategoryThreshold)
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
                adminSetup
                
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
//                    .background(.red)
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
    
    private var cover: some View {
        Color.gray
            .edgesIgnoringSafeArea(.all)
            .ignoresSafeArea(edges: .all)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .opacity(0.2)
            .shadow(radius: 20)
    }
    
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
