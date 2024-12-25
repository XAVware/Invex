//
//  PercentagePickerX.swift
//  InventoryX
//
//  Created by Ryan Smetana on 11/11/24.
//

import SwiftUI

struct PercentagePickerX: View {
    @Environment(FormXViewModel.self) var formVM
    private enum Component { case whole, hundredth }
    @State private var focus: Component = .whole
    @State private var wholeNumber: Int = 0
    @State private var fractionalNumber: Int = 0
    
    let save: (Double) -> Void
    
    private var taxRate: Double {
        return (Double((wholeNumber * 100) + fractionalNumber) / 10000)
    }
    
    init(tax: Double, save: @escaping (Double) -> Void) {
        let w = floorl(tax * 100)
        let d = (tax * 10000) - w * 100
        self.wholeNumber = Int(w)
        self.fractionalNumber = Int(d)
        self.save = save
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            HStack(alignment: .bottom) {
                Text("\(wholeNumber)")
                    .padding(8)
                    .modifier(XOutlineMod(isSelected: focus == .whole))
                    .onTapGesture {
                        withAnimation {
                            focus = .whole
                        }
                    }
                
                Text(".")
                
                Text(String(format: "%02d", fractionalNumber))
                    .padding(8)
                    .modifier(XOutlineMod(isSelected: focus == .hundredth))
                    .onTapGesture {
                        withAnimation {
                            focus = .hundredth
                        }
                    }
                
                Text("%")
                    .padding(.vertical, 8)
            } //: HStack
            .font(.largeTitle)
            
            Group {
                if focus == .whole {
                    Picker("Whole Number", selection: $wholeNumber) {
                        ForEach(0 ..< 99) { value in
                            Text("\(value)").tag(value)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .font(.largeTitle)
                    
                } else {
                    Picker("Fractional Number", selection: $fractionalNumber) {
                        ForEach(0 ..< 99) { value in
                            Text(String(format: "%02d", value)).tag(value)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .font(.largeTitle)
                }
            } //: Group
            .frame(height: 180)
            .frame(maxWidth: 360)
            
            PrimaryButtonPanelX(onCancel: {
                formVM.closeContainer(withValue: taxRate.toPercentageString())
            }, onSave: {
                save(taxRate)
                formVM.forceClose()
            })
        } //: VStack
    }
}




#Preview {
    PercentagePickerX(tax: 0.0625, save: { v in
        
    })
}
