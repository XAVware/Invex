//
//  OnboardingCategoriesView.swift
//  InventoryTracker_10.2021
//
//  Created by Ryan Smetana on 10/15/21.
//

import SwiftUI

struct OnboardingCategoriesView: View {
    @ObservedObject var coordinator: OnboardingCoordinator
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
                if coordinator.checkIfCategoryExists(newCategoryName) == true {
                    //Display error - category exists
                } else {
                    coordinator.createCategory(categoryName: self.newCategoryName)
                    
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
            
            List(coordinator.categoryList) { category in
                HStack {
                    Text(category.name)
                    
                    Spacer()
                    
                    Button(action: {
                        coordinator.deleteCategory(category.name)
                    }) {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                    } //: Button - Delete
                    .buttonStyle(BorderlessButtonStyle())
                } //: HStack
            } //: List
            
            Button(action: {
                guard self.newCategoryName != "" else {
                    //Display Error
                    return
                }
                
                if coordinator.checkIfCategoryExists(newCategoryName) == true {
                    //Display error - category exists
                } else {
                    coordinator.createCategory(categoryName: self.newCategoryName)
                    
                    self.newCategoryName = ""
                    
                    coordinator.nextScreen()
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
