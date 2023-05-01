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
            HStack(spacing: 16) {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                VStack {
                    Text("Ryan")
                        .modifier(TextMod(.title3, .medium, Color(XSS.S.color80)))
                    Text("Admin")
                        .modifier(TextMod(.footnote, .regular, lightTextColor))
                }
                
            } //: HStack
            .foregroundColor(Color(XSS.S.color80))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading)
            
            

            Divider()
                .background(Color(XSS.S.color80))
                .padding(.vertical)
            
            ForEach(DisplayStates.allCases, id: \.self) { displayState in
                Button {
                    currentDisplay = displayState
                } label: {
                    Image(systemName: displayState.iconName)
                        .imageScale(.medium)
                        .bold()
                    
                    Text("\(displayState.menuButtonText)")
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding()
                .frame(height: 50)
                .frame(maxWidth: .infinity)
                .overlay(currentDisplay == displayState ? Color(XSS.S.color60).opacity(0.3) : nil)
            }
            
            Button {
                deleteAllFromRealm()
            } label: {
                Image(systemName: "arrow.triangle.2.circlepath")
                    .imageScale(.medium)
                    .bold()
                
                Text("Reset")
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding()
            .frame(height: 50)
            .frame(maxWidth: .infinity)
            
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
        .padding(.vertical)
        .background(Color(XSS.S.color20))
        .modifier(TextMod(.title3, .semibold, lightTextColor))
        .edgesIgnoringSafeArea(.bottom)
    }
    
    func deleteAllFromRealm() {
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
    }
    
    
}


struct MenuView_Previews: PreviewProvider {
    @State static var display: DisplayStates = .makeASale
    static var previews: some View {
        MenuView(currentDisplay: $display)
    }
}

