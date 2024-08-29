//
//  MoveItemsView.swift
//  InventoryX
//
//  Created by Ryan Smetana on 4/18/24.
//

import SwiftUI

struct MoveItemsView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var vm = MoveItemsViewModel()
    @State var fromDepartment: DepartmentEntity?
    @State var toDepartment: DepartmentEntity?
    
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 8) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                }
                .font(.title)
                
                Text("Move items")
                    .font(.largeTitle)
            } //: VStack
            .fontDesign(.rounded)
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
            
            HStack(spacing: 24) {
                VStack(alignment: .leading) {
                    Text("From:")
                    DepartmentPicker(selectedDepartment: $fromDepartment)
                        .frame(height: 48)
                }
                
                VStack {
                    Spacer().frame(height: 24)
                    Image(systemName: "arrow.forward")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24)
                }
                
                VStack(alignment: .leading) {
                    Text("To:")
                    DepartmentPicker(selectedDepartment: $toDepartment)
                        .frame(height: 48)
                }
            }
            .frame(height: 72)
            
            Spacer()
            
            Button {
                Task {
                    await vm.moveItems(from: fromDepartment, to: toDepartment) { error in
                        guard error == nil else { return }
                        dismiss()
                    }
                }
            } label: {
                Spacer()
                Text("Move Items")
                Spacer()
            }
            .modifier(PrimaryButtonMod())
            .disabled(fromDepartment == nil || toDepartment == nil )
            Spacer()
        } //: VStack
        .frame(maxWidth: 720)
        .padding()
        .background(Color.clear)
    }
}

//#Preview {
//    MoveItemsView()
//}
