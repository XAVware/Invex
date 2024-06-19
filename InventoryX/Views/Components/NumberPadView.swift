
//  LockScreenView.swift
//  InventoryX
//
//  Created by Ryan Smetana on 3/18/24.


import SwiftUI

struct NumberPadView: View {
    @Binding var passcode: String
    
    private func addValue(_ value: Int) {
        if passcode.count < 4 {
            passcode += "\(value)"
        }
    }
    
    private func removeValue() {
        if !passcode.isEmpty {
            passcode.removeLast()
        }
    }
    
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(), count: 3)) {
            ForEach(1 ... 9, id: \.self) { number in
                Button {
                    addValue(number)
                } label: {
                    Text("\(number)")
                        .font(.title)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical)
                }
            }
            
            Button {
                removeValue()
            } label: {
                Image(systemName: "delete.backward")
                    .font(.title)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical)
            }
            
            Button {
                passcode.append("0")
            } label: {
                Text("0")
                    .font(.title)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical)
            }
        } //: Lazy V Grid
        .foregroundStyle(.primary)
    }
    
    
}

//#Preview {
//    NumberPadView(passcode: .constant(""))
//}
