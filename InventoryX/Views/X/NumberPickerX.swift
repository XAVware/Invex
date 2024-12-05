//
//  NumberPickerX.swift
//  InventoryX
//
//  Created by Ryan Smetana on 11/17/24.
//

import SwiftUI

struct NumberPickerX: View {
    @Environment(FormXViewModel.self) var formVM
    @State private var number: Int = 0
    
    let save: (Int) -> Void
    
    init(number: Int, save: @escaping (Int) -> Void) {
        self.number = number
        self.save = save
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            Text(number.description)
                .padding(8)
                .modifier(XOutlineMod(isSelected: true))
                .font(.largeTitle)
            
            Picker("Number", selection: $number) {
                ForEach(0 ..< 99) { value in
                    Text(value.description).tag(value)
                }
            }
            .pickerStyle(WheelPickerStyle())
            .font(.largeTitle)
            .frame(height: 180)
            .frame(maxWidth: 360)
            
            PrimaryButtonPanelX(onCancel: {
                formVM.closeContainer(withValue: number.description)
            }, onSave: {
                save(number)
                formVM.forceClose()
            })
        } //: VStack
    }
}
