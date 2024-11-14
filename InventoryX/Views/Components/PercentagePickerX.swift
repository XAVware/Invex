//
//  PercentagePickerX.swift
//  InventoryX
//
//  Created by Ryan Smetana on 11/11/24.
//

import SwiftUI

struct PercentagePickerX: View {
    private enum Component { case whole, hundredth }
    @State private var focus: Component = .whole
    @State private var wholeNumber: Int = 0
    @State private var fractionalNumber: Int = 0
    
    let save: (Double) -> Void
    
    private var taxRate: Double {
        return Double(wholeNumber) + Double(fractionalNumber) / 100.0
    }
    
    init(tax: Double, save: @escaping (Double) -> Void) {
        let t = tax * 100
        let w = floorl(t)
        self.wholeNumber = Int(w)
        self.fractionalNumber = Int(t.truncatingRemainder(dividingBy: w == 0 ? 1 : w) * 100)
        self.save = save
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .bottom) {
                Text("\(wholeNumber)")
                    .padding(8)
                    .modifier(RoundedOutlineMod(cornerRadius: 7, borderColor: focus == .whole ? Color.black : Color.neoUnderDark, lineWidth: 1.5))
                    .onTapGesture {
                        withAnimation {
                            focus = .whole
                        }
                    }
                
                Text(".")
                
                Text(String(format: "%02d", fractionalNumber))
                    .padding(8)
                    .modifier(RoundedOutlineMod(cornerRadius: 7,
                                                borderColor: focus == .hundredth ? Color.black : Color.neoUnderDark,
                                                lineWidth: 1.5))
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
                } else {
                    Picker("Fractional Number", selection: $fractionalNumber) {
                        ForEach(0 ..< 99) { value in
                            Text(String(format: "%02d", value)).tag(value)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                }
            } //: HStack
            .frame(height: 120)
            .frame(maxWidth: 360)
            .background(Color.fafafa)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            
            Button {
                save(taxRate)
            } label: {
                Text("Save").font(.headline)
            }
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.roundedRectangle)
            .controlSize(.large)
        } //: VStack
    }
}


#Preview {
    PercentagePickerX(tax: 0.0625, save: { v in
        
    })
}
