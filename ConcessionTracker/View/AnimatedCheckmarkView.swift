//
//  SuccessView.swift
//  ConcessionTracker
//
//  Created by Ryan Smetana on 1/21/21.
//

import SwiftUI

struct AnimatedCheckmarkView: View {
    @State var percentage: CGFloat = 0
    @State var isAnimating: Bool = true
    
    private let duration: Double = 1.0
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Circle()
                    .fill(Color.clear)
                    .frame(width: 120, height: 120)
                    .overlay(
                        Circle()
                            .trim(from: 0, to: percentage * 0.01)
                            .stroke(style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
                            .fill(Color("GreenBackground"))
                    )
                    .animation(.spring(response: self.duration, dampingFraction: 1.0, blendDuration: 1.0))
                Image(systemName: "checkmark")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 70, height: 70, alignment: .center)
                    .foregroundColor(Color("GreenBackground"))
                    .scaleEffect(self.isAnimating ? 0.8 : 1)
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    withAnimation(.easeOut(duration: self.duration)) {
                        self.percentage = 100
                        self.isAnimating = false
                    }
                }
                
            }
            Spacer().frame(height: 30)
            Text("Successfully Saved")
                .font(.system(size: 24, weight: .semibold, design: .rounded))
                .foregroundColor(Color("GreenBackground"))
        }
        
        
    }
}

struct AnimatedCheckmarkView_Previews: PreviewProvider {
    static var previews: some View {
        AnimatedCheckmarkView().previewLayout(.sizeThatFits)
    }
}
