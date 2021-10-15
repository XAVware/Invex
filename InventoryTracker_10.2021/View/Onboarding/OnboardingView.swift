//
//  OnboardingView.swift
//  InventoryTracker_10.2021
//
//  Created by Ryan Smetana on 10/14/21.
//

import SwiftUI


struct OnboardingView: View {
    @State var tabViewIndex: Int = 0
    @State var newCategoryName: String = ""
    
    
        enum OnboardingStates {
            case start, categoryNames, categoryRestock, adminPasscode
        }
        
        @State var currentOnboardingState: OnboardingStates     = .start
        //        @State var categories: [Category]                       = []
        @State var adminPasscode: String                        = ""
        
        //    @Binding var isOnboarding: Bool
//        @Binding var displayState: DisplayStates
        
        //        var results: Results<Category> {
        //            return try! Realm().objects(Category.self)
        //        }
        
        var body: some View {
            VStack {
                switch(currentOnboardingState) {
                case .start:
                    OnboardingFirstView()
                    
                    
                case .categoryNames:
                    OnboardingCategoriesView()
                    
                    
                case .categoryRestock:
                    OnboardingRestockView()
                    
                    
                case .adminPasscode:
                    OnboardingPasscodeView()
                    
                } //: Switch
                
                
                Spacer().frame(maxHeight: 50)
            } //: VStack
            .padding()
            .frame(maxWidth: 500)
//            .onTapGesture {
//                print(self.results.count)
//            }
        
        
        
        
        //        func savePasscodeAndProceed() {
        //            self.displayState = .makeASale
        //        }
        
        //        func saveCategories() {
        //            let realm = try! Realm()
        //            for category in categories {
        //                categoryList.append(category)
        //                try! realm.write ({
        //                    realm.add(category)
        //                })
        //            }
        //
        //
    }
}
//
//struct OnboardingView_Previews: PreviewProvider {
//    static var previews: some View {
//        OnboardingView()
//    }
//}

