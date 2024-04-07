//
//  OnboardingView.swift
//  InventoryX
//
//  Created by Smetana, Ryan on 4/24/23.
//

import SwiftUI
import RealmSwift


enum OnboardingState: Int {
    case start = 0
    case setPasscode = 1
    case department = 2
    case item = 3
    
    var viewTitle: String {
        return switch self {
        case .start: "Welcome to InveX!"
        case .setPasscode: "Set a passcode"
        case .department: "Add a department"
        case .item: "Add an item"
        }
    }
    
}


struct OnboardingView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.verticalSizeClass) var vSize
    @State var currentDisplay: OnboardingState = .start

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                
                VStack(alignment: .leading, spacing: 16) {
                    if currentDisplay != .start {
                        Button {
                            guard let prevPage = OnboardingState(rawValue: currentDisplay.rawValue - 1) else { return }
                            
                            currentDisplay = prevPage
                        } label: {
                            Image(systemName: "chevron.left")
                            Spacer()
                            Text("Back")
                        }
                        .padding(.horizontal, 12)
                        .modifier(SecondaryButtonMod())
                    } else {
                        LogoView()
                    }
                    
                    Text(currentDisplay.viewTitle)
                        .modifier(TitleMod())
                } //: VStack
                .frame(maxWidth: .infinity)
                
                
                switch currentDisplay {
                case .start:
                    Text("Start by telling us a little bit about your business.")
                        .font(.title2)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    CompanyDetailView(company: nil, showTitles: false) {
                        currentDisplay = .setPasscode
                    }
                    .padding(.vertical)
                    .frame(maxHeight: .infinity)
                    
                case .setPasscode:
                    Spacer()
                    ChangePasscodeView() {
                        currentDisplay = .department
                    }
                    Spacer()
                case .department:
                    
                    DepartmentDetailView(department: DepartmentEntity(), showTitles: false) {
                        currentDisplay = .item
                    }
                    
                    
                case .item:
                    AddItemView(item: ItemEntity(), showTitles: false) {
                        dismiss()
                    }
                    
                } //: Switch
                
            } //: VStack
            .padding(.horizontal)
            .padding(.top)
        }
    } //: Body
    
    
}

#Preview {
    OnboardingView()
        .environment(\.realm, DepartmentEntity.previewRealm)
}
