//
////  LockScreenView.swift
////  InventoryX
////
////  Created by Ryan Smetana on 3/18/24.
//
//
//import SwiftUI
//
//struct NumberPadView: View {
//    @Environment(\.colorScheme) var colorScheme
//    @Binding var passcode: String
//    
//    private func addValue(_ value: Int) {
//        if passcode.count < 4 {
//            passcode += "\(value)"
//        }
//    }
//    
//    private func removeValue() {
//        if !passcode.isEmpty {
//            passcode.removeLast()
//        }
//    }
//    
//    var body: some View {
//        LazyVGrid(columns: Array(repeating: GridItem(spacing: 4), count: 3), spacing: 4) {
//            ForEach(1 ... 9, id: \.self) { number in
//                Button("\(number)") {
//                    addValue(number)
//                }
//                .buttonStyle(NumberPadButtonStyle())
//            }
//            
//            Button(".") {
//                passcode.append("0")
//            }
//            .fontWeight(.heavy)
//            .buttonStyle(NumberPadButtonStyle())
//            
//            Button("0") {
//                passcode.append("0")
//            }
//            .buttonStyle(NumberPadButtonStyle())
//            
//            Button("", systemImage: "delete.backward") {
//                removeValue()
//            }
//            .buttonStyle(NumberPadButtonStyle())
//        } //: Lazy V Grid
//        .foregroundStyle(.primary)
//        .background(Color.bg)
//    }
//    
//    
//}
//
//#Preview {
//    NumberPadView(passcode: .constant(""))
//}
//
//
//
