//
//  OnboardingCategoriesView.swift
//  InventoryTracker_10.2021
//
//  Created by Ryan Smetana on 10/15/21.
//

import SwiftUI

struct OnboardingCategoriesView: View {
    var body: some View {
        VStack {
            Text("First, Let's Add Some Categories")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color.blue)
                .padding()
            
            Text("ConcessionTracker displays your inventory on each page based on their category.")
                .font(.callout)
                .foregroundColor(Color.blue)
                .multilineTextAlignment(.center)
            
            Spacer().frame(height: 50)
            
//            TextField("Category Name:", text: $newCategoryName)
//                .modifier(TextFieldModifier())
            
            Button(action: {
//                for category in categories {
//                    if category.name == newCategoryName {
//                        print("category already exists")
//                        return
//                    }
//                }
//
//                let newCategory: Category = Category()
//                newCategory.name = self.newCategoryName
//
//                self.categories.append(newCategory)
//
//                self.newCategoryName = ""
                
            }, label: {
                Text("+ Save and Add Another Category")
            })
                .foregroundColor(Color.blue)
                .padding()
            
            Divider()
            
            VStack(spacing: 25) {
                Text("Current Categories:")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(Color.blue)
                    .opacity(0.8)
                
                ScrollView(.vertical, showsIndicators: false, content: {
                    VStack {
//                        ForEach(categories, id: \.self) { category in
//                            HStack {
//                                Text(category.name)
//
//                                Spacer()
//
//                                Button(action: {
//                                    guard let index = self.categories.firstIndex(of: category) else {
//                                        print("Error deleting category")
//                                        return
//                                    }
//                                    self.categories.remove(at: index)
//
//                                }) {
//                                    Image(systemName: "trash")
//                                        .foregroundColor(.red)
//                                } //: Button - Delete
//
//                            }//: HStack
//                            .frame(height: 40)
//
//                            Divider().opacity(0.5)
//                        }//: ForEach
                        
                    }//: VStack
                    .frame(maxWidth: 400)
                })
            } //: VStack - Current Categories
            
            Button(action: {
//                if self.newCategoryName != "" {
//                    for category in categories {
//                        if category.name == newCategoryName {
//                            print("category already exists")
//                            return
//                        }
//                    }
//
//                    let newCategory: Category = Category()
//                    newCategory.name = self.newCategoryName
//
//                    self.categories.append(newCategory)
//                }
//                self.currentOnboardingState = .categoryRestock
            }, label: {
                Text("Save & Continue")
                    .font(.title)
                    .foregroundColor(.white)
            })
                .padding()
                .frame(width: 350, height: 50)
                .foregroundColor(Color.blue)
                .cornerRadius(25)
        }
    }
}

struct OnboardingCategoriesView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingCategoriesView()
    }
}
