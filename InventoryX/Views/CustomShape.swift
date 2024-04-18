//
//  CustomShape.swift
//  InventoryX
//
//  Created by Ryan Smetana on 4/16/24.
//

import SwiftUI

struct CustomShape: View {
    var body: some View {
        
        VStack {
            
            InverseRoundedRectangleShape(direction: .trailing)
                .fill(.red)
                .frame(height: 50)
                .shadow(radius: 6)
                .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
        }
    }
}

#Preview {
    CustomShape().padding()
}


struct InverseRoundedRectangleShape: Shape {
    let direction: HorizontalAlignment
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        // Begin at the left of the screen, 25px above where the main rectangle begins to leave room for the curve
        path.move(to: CGPoint(x: 0, y: -25))


        path.addQuadCurve(to: CGPoint(x: 50, y: 0),
                          control: CGPoint(x: 16, y: 0))
        
        // End of the top curve
        path.addLine(to: CGPoint(x: 50, y: 0))
        
        // to top right
        path.addLine(to: CGPoint(x: rect.width, y: 0))

        // to bottom right
        path.addLine(to: CGPoint(x: rect.width, y: rect.height))

        path.addLine(to: CGPoint(x: 50, y: rect.height))
        
        path.addQuadCurve(to: CGPoint(x: 0, y: rect.height + 25),
                          control: CGPoint(x: 16, y: 50))
        
        // to bottom left
        
//        let yRot = direction == .trailing ? 1 : 0

        return path
    }
}
