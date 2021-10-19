//
//  OnboardingView.swift
//  InventoryTracker_10.2021
//
//  Created by Ryan Smetana on 10/14/21.
//

import SwiftUI


struct OnboardingView: View {
    @StateObject var onboardingCoordinator: OnboardingCoordinator = OnboardingCoordinator()
    
    var body: some View {
        VStack {
            switch(onboardingCoordinator.screenIndex) {
            case 0:
                OnboardingFirstView(onboardingCoordinator: self.onboardingCoordinator)
                
            case 1:
                OnboardingCategoriesView(onboardingCoordinator: self.onboardingCoordinator)
                
            case 2:
                OnboardingRestockView(onboardingCoordinator: self.onboardingCoordinator)
                
            case 3:
                OnboardingPasscodeView(onboardingCoordinator: self.onboardingCoordinator)
                
            default:
                OnboardingFirstView(onboardingCoordinator: self.onboardingCoordinator)
                
            } //: Switch
            
            
            Spacer().frame(maxHeight: 50)
        } //: VStack
        .padding()
        .frame(maxWidth: 500)
        .onTapGesture {
            print(onboardingCoordinator.categoryList)
        }
        
        
        
        
        
        //        func savePasscodeAndProceed() {
        //            self.displayState = .makeASale
        //        }
        //
        //        func saveCategories() {
        //            let realm = try! Realm()
        //            for category in categories {
        //                categoryList.append(category)
        //                try! realm.write ({
        //                    realm.add(category)
        //                })
        //            }
        //        }
    }
}
//
//struct OnboardingView_Previews: PreviewProvider {
//    static var previews: some View {
//        OnboardingView()
//    }
//}

