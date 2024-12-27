//
//  ContainerX.swift
//  InventoryX
//
//  Created by Ryan Smetana on 11/11/24.
//

import SwiftUI

// MARK: - ContainerX View
struct ContainerX<C: View>: View {
    @Environment(FormXViewModel.self) var formVM
    @State private var id: UUID = UUID()
    @State var title: String
    @State var description: String
    let value: String
    let content: C

    var isExpanded: Bool { formVM.expandedContainer == id }
    
    init(data: ContainerXModel, value: String, @ViewBuilder content: (() -> C)) {
        self.id = data.id
        self.title = data.title
        self.description = data.description
        self.value = value
        self.content = content()
    }
    
    private var divider: some View {
        DividerX().opacity(formVM.expandedContainer == nil ? 1 : 0)
    }
    
    var body: some View {
        @Bindable var formVM: FormXViewModel = formVM
        // Only show the container if it is the selected container or if there is no other container selected.
        if isExpanded || formVM.expandedContainer == nil {
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
                .overlay(divider, alignment: .bottom)
                .transition(.opacity)
                .animation(.interpolatingSpring, value: formVM.expandedContainer == nil)
                .animation(.interpolatingSpring, value: isExpanded)
        }
    } //: Body
    
    @ViewBuilder private var contentView: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .center) {
                if !formVM.labelsHidden {
                    VStack(alignment: .leading, spacing: isExpanded ? 8 : 6) {
                        // Title is displayed large like th
                        Text(title)
                            .font(isExpanded ? .largeTitle : .body)
                        
                        Text((value.isEmpty || isExpanded) ? description : value)
                            .opacity(0.5)
                            .padding(.trailing, isExpanded ? 48 : 0)
                            .font(isExpanded ? .headline : .body)
                    } //: VStack
                }
                
                
                Spacer()
                
                // Only show button when the container is not already expanded.
                if !isExpanded {
                    Button(value.isEmpty ? "Add" : "Edit") {
                        formVM.expandContainer(id: self.id)
                        formVM.setOrigValue(self.value)
                    }
                    .frame(maxWidth: 48)
                    .underline()
                    .buttonStyle(.plain)
                    .background(Color.bg.opacity(0.001).padding(-14)) // Creates larger 'tappable' area
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
    } //: Content View
}

#Preview {
    ContainerX(data: ContainerXModel(title: "Title", description: "Here's a Short description"), value: "XAV", content: {
        
    })
    .environment(FormXViewModel())
}

// MARK: - Container Model
struct ContainerXModel {
    let id: UUID = UUID()
    let title: String
    let description: String
}
