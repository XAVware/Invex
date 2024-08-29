//
//  OnboardingView.swift
//  InventoryX
//
//  Created by Smetana, Ryan on 4/24/23.
//

import SwiftUI
import RealmSwift

struct OnboardingView: View {
    @Environment(\.dismiss) var dismiss
//    @Environment(\.horizontalSizeClass) var hSize
//    @Environment(\.verticalSizeClass) var vSize
    
    @State var path: NavigationPath = .init()
    
    var body: some View {
        NavigationStack(path: $path) {
            LandingView(path: $path)
                .navigationDestination(for: LSXDisplay.self) { view in
                    switch view {
                    case .company(let c, let t):
                        CompanyDetailView(company: c, detailType: t) {
                            path.append(LSXDisplay.passcodePad([.set]))
                        }
                        
                    case .passcodePad(let p):
                        PasscodeView(processes: p) {
                            path.append(LSXDisplay.department(nil, .onboarding))
                        }
                        
                    case .department(let d, let t):
                        DepartmentDetailView(department: d, detailType: t) {
                            path.append(LSXDisplay.item(nil, .onboarding))
                        }
                        
                    case .item(let i, let t):
                        ItemDetailView(item: i, detailType: t) {
                            dismiss()
                        }
                        
                    default: Color.black
                    }
                    
                }
        } //: Navigation Stack
    } //: Body
}

#Preview {
    OnboardingView()
        .environment(\.realm, DepartmentEntity.previewRealm)
}
