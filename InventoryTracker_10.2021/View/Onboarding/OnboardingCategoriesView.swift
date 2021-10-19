//
//  OnboardingCategoriesView.swift
//  InventoryTracker_10.2021
//
//  Created by Ryan Smetana on 10/15/21.
//

import SwiftUI

struct OnboardingCategoriesView: View {
    @ObservedObject var onboardingCoordinator: OnboardingCoordinator
    @State var newCategoryName: String = ""
    
    var body: some View {
        VStack {
            VStack(spacing: 20){
                Text("First, Let's Add Some Categories")
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                
                Text("ConcessionTracker displays your inventory on each page based on their category.")
                    .font(.callout)
                    .multilineTextAlignment(.center)
            }
            .foregroundColor(Color.blue)
            
            
            
            Spacer().frame(height: 50)
            
            TextField("Category Name:", text: $newCategoryName)
            //                .modifier(TextFieldModifier())
            
            Button(action: {
                if onboardingCoordinator.checkIfCategoryExists(newCategoryName) == true {
                    //Display error - category exists
                } else {
                    onboardingCoordinator.createCategory(categoryName: self.newCategoryName)
                    
                    self.newCategoryName = ""
                }
                
            }, label: {
                Text("+ Save and Add Another Category")
            })
            .foregroundColor(Color.blue)
            .padding()
            
            Divider()
            
            Text("Current Categories:")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(Color.blue)
                .opacity(0.8)
            
            List(onboardingCoordinator.categoryList) { category in
                HStack {
                    Text(category.name)
                    
                    Spacer()
                    
                    Button(action: {
                        onboardingCoordinator.deleteCategory(category.name)
                    }) {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                    } //: Button - Delete
                    .buttonStyle(BorderlessButtonStyle())
                } //: HStack
            } //: List
            
            Button(action: {
                if newCategoryName == "" && onboardingCoordinator.categoryList.isEmpty {
                    //Display Error - you need at least one category
                    return
                } else if newCategoryName == "" {
                    onboardingCoordinator.nextScreen()
                    return
                } else {
                    if onboardingCoordinator.checkIfCategoryExists(newCategoryName) == true {
                        //Display error - category exists
                    } else {
                        onboardingCoordinator.createCategory(categoryName: self.newCategoryName)
                        self.newCategoryName = ""
                        onboardingCoordinator.nextScreen()
                    }
                }

            }, label: {
                Text("Save & Continue")
                    .font(.title)
                    .foregroundColor(.black)
            })
            .padding()
            .frame(width: 350, height: 50)
            .foregroundColor(Color.blue)
            .cornerRadius(25)
        }
        .padding()
    }
}

//struct OnboardingCategoriesView_Previews: PreviewProvider {
//    static var previews: some View {
//        OnboardingCategoriesView()
//    }
//}
