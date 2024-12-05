//
//  ContainerX.swift
//  InventoryX
//
//  Created by Ryan Smetana on 11/11/24.
//

import SwiftUI

struct ContainerX<C: View>: View {
    @Environment(FormXViewModel.self) var formVM
    
    @State var title: String
    @State var description: String
    let value: String
    let content: C
    @State private var id: UUID = UUID()
    
    var isExpanded: Bool { formVM.expandedContainer == id }
    
    init(data: ContainerXModel, value: String, @ViewBuilder content: (() -> C)) {
        self.id = data.id
        self.title = data.title
        self.description = data.description
        self.value = value
        self.content = content()
    }
    
    var body: some View {
        @Bindable var formVM: FormXViewModel = formVM
        contentView
            .padding(.vertical)
            .onTapGesture {
                formVM.onTapOutside?()
            }
            .alert("Unsaved Changes\nAre you sure you want to discard your unsaved changes?", isPresented: $formVM.showAlert, actions: {
                Button("Cancel", role: .cancel) { }
                Button("Discard", role: .destructive) {
                    formVM.forceClose()
                }
            })
    } //: Body
    
    @ViewBuilder private var contentView: some View {
        if isExpanded || formVM.expandedContainer == nil {
            VStack(alignment: .leading, spacing: 12) {
                HStack(alignment: .center) {
                    VStack(alignment: .leading, spacing: isExpanded ? 8 : 6) {
                        Text(title)
                            .font(isExpanded ? .largeTitle : .body)
                                            
                        Text((value.isEmpty || isExpanded) ? description : value)
                            .opacity(0.5)
                            .padding(.trailing, isExpanded ? 48 : 0)
                            .font(isExpanded ? .headline : .body)
                        
                    } //: VStack
                    
                    Spacer()
                    
                    if !isExpanded {
                        Button(value.isEmpty ? "Add" : "Edit") {
                            formVM.expandContainer(id: self.id)
                            formVM.setOrigValue(self.value)
                        }
                        .frame(maxWidth: 48)
                        .underline()
                        .buttonStyle(.plain)
                    }
                } //: HStack
                .fontWeight(.medium)
                .fontDesign(.rounded)
                
                if isExpanded {
                    content
                        .padding(.vertical)
                        .environment(formVM)
                }
                
            } //: VStack
        }
    } //: Content View
}

#Preview {
    ContainerX(data: ContainerXModel(title: "Title", description: "Here's a Short description"), value: "XAV", content: {
        
    })
    .environment(FormXViewModel())
}
