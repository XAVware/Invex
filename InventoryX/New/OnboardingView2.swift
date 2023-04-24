//
//  OnboardingView2.swift
//  InventoryX
//
//  Created by Smetana, Ryan on 4/24/23.
//

import SwiftUI
import RealmSwift

@MainActor class OnboardingViewModel: ObservableObject {
    var navCount: Int = 0
    
    func nextTapped() {
        navCount += 1
    }
}

struct OnboardingView2: View {
    @StateObject var vm: OnboardingViewModel = OnboardingViewModel()
    
    enum OnboardingStates {
        case start, categoryNames, categoryRestock, adminPasscode
    }
    
    @State var currentOnboardingState: OnboardingStates     = .start
    @State var categories: [Category]                       = []
    @State var newCategoryName: String                      = ""
    @State var adminPasscode: String                        = ""
    
    @Binding var isOnboarding: Bool
    
    
//    var results: Results<Category> {
//        return try! Realm().objects(Category.self)
//    }
    
    var body: some View {
        VStack {
            switch(currentOnboardingState) {
            case .start:
                VStack {
                    Text("Welcome to ConcessionTracker!")
                    
                    Spacer()
                    
                    continueButton
                } //: VStack
                
            case .categoryNames:
                Text("First, Let's Add Some Categories")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color("ThemeColor"))
                    .padding()

                Text("ConcessionTracker displays your inventory on each page based on their category.")
                    .font(.callout)
                    .foregroundColor(Color("ThemeColor"))
                    .multilineTextAlignment(.center)

                Spacer().frame(height: 50)

                TextField("Category Name:", text: $newCategoryName)
                    .modifier(TextFieldModifier())

                Button(action: {
                    for category in categories {
                        if category.name == newCategoryName {
                            print("category already exists")
                            return
                        }
                    }
                    
                    let newCategory: Category = Category()
                    newCategory.name = self.newCategoryName

                    self.categories.append(newCategory)

                    self.newCategoryName = ""

                }, label: {
                    Text("+ Save and Add Another Category")
                })
                .foregroundColor(Color("ThemeColor"))
                .padding()

                Divider()

                VStack(spacing: 25) {
                    Text("Current Categories:")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(Color("ThemeColor"))
                        .opacity(0.8)

                    ScrollView(.vertical, showsIndicators: false, content: {
                        VStack {
                            ForEach(categories, id: \.self) { category in
                                HStack {
                                    Text(category.name)

                                    Spacer()

                                    Button(action: {
                                        guard let index = self.categories.firstIndex(of: category) else {
                                            print("Error deleting category")
                                            return
                                        }
                                        self.categories.remove(at: index)

                                    }) {
                                        Image(systemName: "trash")
                                            .foregroundColor(.red)
                                    } //: Button - Delete

                                }//: HStack
                                .frame(height: 40)

                                Divider().opacity(0.5)
                            }//: ForEach

                        }//: VStack
                        .frame(maxWidth: 400)
                    })
                } //: VStack - Current Categories

                Button(action: {
                    if self.newCategoryName != "" {
                        for category in categories {
                            if category.name == newCategoryName {
                                print("category already exists")
                                return
                            }
                        }
                        
                        let newCategory: Category = Category()
                        newCategory.name = self.newCategoryName
                        
                        self.categories.append(newCategory)
                    }
                    self.currentOnboardingState = .categoryRestock
                }, label: {
                    Text("Save & Continue")
                        .font(.title)
                        .foregroundColor(.white)
                })
                .padding()
                .frame(width: 350, height: 50)
                .background(Color("ThemeColor"))
                .cornerRadius(25)

                
                
                
                
                
            case .categoryRestock:
                Text("Next, Select Your Restock Point")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color("ThemeColor"))
                    .padding()
                
                Text("Enter the restock point for each category. ConcessionTracker will alert you when an item in the corresponding category needs to be restocked.")
                    .font(.callout)
                    .foregroundColor(Color("ThemeColor"))
                    .multilineTextAlignment(.center)
                
                Spacer().frame(height: 50)
                
                
                Divider()
                
                VStack(spacing: 25) {
                    Text("Your Categories:")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(Color("ThemeColor"))
                        .opacity(0.8)
                    
                    ScrollView(.vertical, showsIndicators: false, content: {
                        VStack {
                            ForEach(categories, id: \.self) { category in
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
            
                Button(action: {
                    self.saveCategories()
                    self.currentOnboardingState = .adminPasscode
                }, label: {
                    Text("Save & Continue")
                        .font(.title)
                        .foregroundColor(.white)
                })
                .padding()
                .frame(width: 350, height: 50)
                .background(Color("ThemeColor"))
                .cornerRadius(25)
                
                
            case .adminPasscode:
                Text("Finally, enter an admin passcode")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color("ThemeColor"))
                    .padding()
                
                Text("This passcode should be used by administrators to access features such as inventory adjustments")
                    .font(.callout)
                    .foregroundColor(Color("ThemeColor"))
                    .multilineTextAlignment(.center)
                
                Spacer()
                
                                
                PasscodePad(padState: .setPasscode, finishAction: {
                    self.savePasscodeAndProceed()
                })
                    .padding()
            
            } //: Switch
            
            
            Spacer().frame(maxHeight: 50)
        } //: VStack
        .padding()
        .frame(maxWidth: 500)
    }
    
    private var continueButton: some View {
        Button(action: {
            vm.nextTapped()
//            self.currentOnboardingState = .categoryNames
        }, label: {
            Text("Get Started")
                .modifier(TextMod(.title, .regular, secondaryColor))
                .frame(maxWidth: .infinity)
        })
        .modifier(RoundedButtonMod())
    } //: Continue Button
    
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
}

struct OnboardingView2_Previews: PreviewProvider {
    @State static var onboarding: Bool = true
    static var previews: some View {
        OnboardingView2(isOnboarding: $onboarding)
    }
}
