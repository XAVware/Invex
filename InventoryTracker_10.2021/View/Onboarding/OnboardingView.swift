//
//  OnboardingView.swift
//  InventoryTracker_10.2021
//
//  Created by Ryan Smetana on 10/14/21.
//

import SwiftUI


struct OnboardingView: View {
    @StateObject var coordinator: OnboardingCoordinator = OnboardingCoordinator()
    
    var body: some View {
        VStack {
            switch(coordinator.screenIndex) {
            case 0:
                OnboardingFirstView(coordinator: self.coordinator)
                
            case 1:
                OnboardingCategoriesView(coordinator: self.coordinator)
                
            case 2:
                OnboardingRestockView(coordinator: self.coordinator)
                
            case 3:
                OnboardingPasscodeView(coordinator: self.coordinator)
                
            default:
                OnboardingFirstView(coordinator: self.coordinator)
                
            } //: Switch
            
            
            Spacer().frame(maxHeight: 50)
        } //: VStack
        .padding()
        .frame(maxWidth: 500)
        .onTapGesture {
            print(self.coordinator.categoryList)
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

