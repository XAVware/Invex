//
//  MoveItemsView.swift
//  InventoryX
//
//  Created by Ryan Smetana on 4/18/24.
//

import SwiftUI

@MainActor class MoveItemsViewModel: ObservableObject {
    func moveItems(from fromDept: DepartmentEntity?, to toDept: DepartmentEntity?, completion: @escaping ((Error?) -> Void)) async {
        guard let fromDept = fromDept, let toDept = toDept else {
            print("No departments")
            return
        }
        
        do {
            try await RealmActor().moveItems(from: fromDept, to: toDept)
            completion(nil)
        } catch {
            print(error.localizedDescription)
            completion(error)
        }
    }
}

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
                    DepartmentPicker(selectedDepartment: $fromDepartment, style: .dropdown)
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
                    DepartmentPicker(selectedDepartment: $toDepartment, style: .dropdown)
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

#Preview {
    MoveItemsView()
}
