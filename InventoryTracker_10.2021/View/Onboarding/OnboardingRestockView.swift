//
//  OnboardingRestockView.swift
//  InventoryTracker_10.2021
//
//  Created by Ryan Smetana on 10/15/21.
//

import SwiftUI

struct OnboardingRestockView: View {
    @ObservedObject var onboardingCoordinator: OnboardingCoordinator
    
    var body: some View {
        VStack {
            Text("Next, Select Your Restock Point")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color.blue)
                .padding()
            
            Text("Enter the restock point for each category. ConcessionTracker will alert you when an item in the corresponding category needs to be restocked.")
                .font(.callout)
                .foregroundColor(Color.blue)
                .multilineTextAlignment(.center)
            
            Spacer().frame(height: 50)
            
            
            Divider()
            
            VStack(spacing: 25) {
                Text("Your Categories:")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(Color.blue)
                    .opacity(0.8)
                
                List(onboardingCoordinator.categoryList) { category in
                    HStack {
                        Text(category.name)
                        
                        Spacer()
                        
                        HStack(spacing: 0) {
                            Button(action: {
                                onboardingCoordinator.changeRestockPoint(for: category.name, value: -1)
                            }) {
                                Image(systemName: "minus.circle.fill")
                                    .opacity(0.7)
                            } //: Button
                            .buttonStyle(BorderlessButtonStyle())
                            
                            Text("\(category.restockThresh)")
                                .frame(width: 40)
                                .multilineTextAlignment(.center)
                            
                            Button(action: {
                                onboardingCoordinator.changeRestockPoint(for: category.name, value: 1)
                            }) {
                                Image(systemName: "plus.circle.fill")
                                    .opacity(0.7)
                            } //: Button
                            .buttonStyle(BorderlessButtonStyle())
                        }//: HStack
                        .foregroundColor(.black)
                    } //: HStack
                } //: List
                
                Button(action: {
                    //                    self.saveCategories()
                    onboardingCoordinator.nextScreen()
                }, label: {
                    Text("Save & Continue")
                        .font(.title)
                        .foregroundColor(.blue)
                })
                    .padding()
                    .frame(width: 350, height: 50)
                    .foregroundColor(Color.blue)
                    .cornerRadius(25)
            }
        }
    }
}

//struct OnboardingRestockView_Previews: PreviewProvider {
//    static var previews: some View {
//        OnboardingRestockView()
//    }
//}
