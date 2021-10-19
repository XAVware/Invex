//
//  OnboardingFirstView.swift
//  InventoryTracker_10.2021
//
//  Created by Ryan Smetana on 10/15/21.
//

import SwiftUI

struct OnboardingFirstView: View {
    @ObservedObject var onboardingCoordinator: OnboardingCoordinator
    
    var body: some View {
        VStack {
            Text("Welcome to ConcessionTracker!")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color.blue)
                .padding()
            
            Spacer()
            
            Button(action: {
                onboardingCoordinator.nextScreen()
            }, label: {
                Text("Get Started")
                    .font(.title)
                    .foregroundColor(Color.blue)
            })
                .padding()
                .frame(width: 350, height: 50)
                .foregroundColor(Color.blue)
                .cornerRadius(25)
        }
    }
}

//struct OnboardingFirstView_Previews: PreviewProvider {
//    static var previews: some View {
//        OnboardingFirstView()
//    }
//}
