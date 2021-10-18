//
//  OnboardingRestockView.swift
//  InventoryTracker_10.2021
//
//  Created by Ryan Smetana on 10/15/21.
//

import SwiftUI

struct OnboardingRestockView: View {
    @ObservedObject var coordinator: OnboardingCoordinator
    
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
                
            List(coordinator.categoryList) { category in
                HStack {
                    Text(category.name)
                    
                    HStack(spacing: 0) {
                        Button(action: {
                                guard category.restockThresh >= 0 else {
                                    return
                                }
                                category.restockNumber -= 1
                        }) {
                            Image(systemName: "minus.circle.fill")
                                .opacity(0.7)
                        } //: Button
                        .buttonStyle(BorderlessButtonStyle())

                        Text("\(category.restockThresh)")
                            .frame(width: 40)
                            .multilineTextAlignment(.center)

                        Button(action: {
//                                category.restockNumber += 1
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .opacity(0.7)
                        } //: Button
                        .buttonStyle(BorderlessButtonStyle())
                    }//: HStack
                    .foregroundColor(.black)
                } //: HStack
            } //: List
                
                
                //                ScrollView(.vertical, showsIndicators: false, content: {
                //                    VStack {
                //                        ForEach(categories, id: \.self) { category in
                //                            HStack {
                //                                Text(category.name)
                //
                //                                Spacer()
                //
                //                                HStack(spacing: 0) {
                //                                    Button(action: {
                //                                        guard category.restockNumber >= 0 else {
                //                                            return
                //                                        }
                //                                        category.restockNumber -= 1
                //                                    }) {
                //                                        Image(systemName: "minus.circle.fill")
                //                                            .opacity(0.7)
                //                                    } //: Button
                //
                //                                    Text("\(category.restockNumber)")
                //                                        .frame(width: 40)
                //                                        .multilineTextAlignment(.center)
                //
                //
                //                                    Button(action: {
                //                                        category.restockNumber += 1
                //                                    }) {
                //                                        Image(systemName: "plus.circle.fill")
                //                                            .opacity(0.7)
                //                                    } //: Button
                //                                }//: HStack
                //                                .foregroundColor(.black)
                //
                //                            }//: HStack
                //                            .frame(height: 40)
                //
                //                            Divider().opacity(0.5)
                //                        }//: ForEach
                
                //                    }//: VStack
                //                    .frame(maxWidth: 400)
                //                })
                //            } //: VStack - Current Categories
                
                Button(action: {
                    //                self.saveCategories()
                    //                self.currentOnboardingState = .adminPasscode
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
}

//struct OnboardingRestockView_Previews: PreviewProvider {
//    static var previews: some View {
//        OnboardingRestockView()
//    }
//}
