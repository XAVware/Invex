//
//  MenuView.swift
//  InventoryX
//
//  Created by Smetana, Ryan on 5/1/23.
//

import SwiftUI
import RealmSwift

struct MenuView: View {
    @Binding var currentDisplay: DisplayStates
    
    var body: some View {
        VStack {
            LogoView()
                .frame(maxWidth: .infinity, alignment: .leading)
                .scaleEffect(0.8)
                .padding(.top, 8)
            
            HStack(spacing: 16) {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                
                VStack {
                    Text("Ryan")
                        .modifier(TextMod(.title3, .medium, Theme.secondaryBackground))
                    
                    Text("Admin")
                        .modifier(TextMod(.footnote, .regular, Theme.lightFgColor))
                }
                
            } //: HStack
            .foregroundColor(Theme.secondaryBackground)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading)
            
            Divider()
                .background(Theme.secondaryBackground)
                .padding(.vertical)
            
            ForEach(DisplayStates.allCases, id: \.self) { displayState in
                Button {
                    currentDisplay = displayState
                } label: {
                    Image(systemName: displayState.menuIconName)
                        .imageScale(.medium)
                        .bold()
                    
                    Text("\(displayState.menuButtonText)")
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding()
                .frame(height: 50)
                .frame(maxWidth: .infinity)
                .overlay(currentDisplay == displayState ? Theme.lightFgColor.opacity(0.3) : nil)
            }
            
            Spacer()
            
            Button {
                
            } label: {
                Image(systemName: "rectangle.portrait.and.arrow.forward")
                    .imageScale(.medium)
                    .bold()
                
                Text("Sign Out")
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding()
            .frame(height: 50)
            .frame(maxWidth: .infinity)
        } //: VStack
        .background(Theme.primaryBackground)
        .modifier(TextMod(.title3, .semibold, Theme.lightFgColor))
        .edgesIgnoringSafeArea(.vertical)
    } //: Body
    
    
}


struct MenuView_Previews: PreviewProvider {
    @State static var display: DisplayStates = .makeASale
    static var previews: some View {
        MenuView(currentDisplay: $display)
    }
}

