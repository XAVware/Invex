//
//  LockScreenView.swift
//  InventoryX
//
//  Created by Ryan Smetana on 3/18/24.
//

import SwiftUI

struct LockScreenView: View {
    @State var authenticated: Bool = false
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                DateTimeLabel()
                Spacer()
            } //: VStack
            Spacer()
            VStack(alignment: .center) {
                PasscodeView(isAuthenticated: $authenticated)
                    .frame(maxWidth: 360, maxHeight: 540, alignment: .center)
            } //: VStack
            
        } //: HStack
        .frame(maxWidth: 800)
    }
}

#Preview {
    LockScreenView()
}
