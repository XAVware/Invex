//
//  AlertView.swift
//  VerbalFluency
//
//  Created by Ryan Smetana on 12/31/23.
//

import SwiftUI

struct AlertView: View {
    @State var alert: AlertModel
    
    @State private var offset: CGFloat = -100
    @State private var opacity: CGFloat = 0
    
    private var lineCount: Int {
        var tempCount = 1
        let messageLength = alert.message.count
        
        if messageLength > 52 {
            tempCount = 3
        } else if messageLength > 26 {
            tempCount = 2
        }
        
        return tempCount
    }
    
    private var alertPadding: Int {
        return 8 * lineCount
    }

    private func close() {
        withAnimation(.easeIn(duration: 0.1)) {
            opacity = 0
            offset = -100
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            UIFeedbackService.shared.removeAlert()
        }
    }
    
    private func dragChanged(_ val: DragGesture.Value) {
        if val.translation.height < 0 {
            close()
        }
    }
    
    var body: some View {
        HStack {
            Image(systemName: alert.iconName)
                .resizable()
                .scaledToFit()
                .frame(width: 36)
                .padding()
            
            VStack(alignment: .leading, spacing: 2) {
                Text(alert.title)
                    .font(.caption)
                
                Text(alert.message)
                    .font(.subheadline)
                    .bold()
            } //: VStack
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
            
            Image(systemName: "xmark")
                .resizable()
                .scaledToFit()
                .frame(width: 10)
                .padding(.horizontal)
        } //: HStack
        .transition(.move(edge: .top))
        .foregroundStyle(.white)
        .frame(maxWidth: 400, maxHeight: (56 + CGFloat(alertPadding)))
        .background(
            
            alert.bgColor
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .shadow(radius: 6)
            
        )
        .gesture(DragGesture().onChanged { dragChanged($0) })
        .offset(y: offset)
        .opacity(opacity)
        .onAppear {
            debugPrint(">>> ALERT: \(String(describing: alert.message))")
            withAnimation(.bouncy(duration: 0.1, extraBounce: 0.08)) {
                opacity = 1
                offset = 0
            }
        }
        .onTapGesture {
            Task {
                close()
            }
        }
        .task {
            do {
                try await Task.sleep(nanoseconds: 4_000_000_000)
                close()
            } catch (let cancellationError as CancellationError) {
                debugPrint(">>> User manually closed alert which resulted in a cancellation error. This error is safe to keep in the app. \(cancellationError.localizedDescription)")
            } catch {
                debugPrint(">>> Error from Alert task: \(error.localizedDescription)")
            }
        }
    } //: Body
    
    private var viewBackground: some View {
        alert.bgColor
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .shadow(radius: 6)
    } //: View Background
    
    
}


#Preview {
    AlertView(alert: AlertModel(type: .error, message: "Uh oh! Something went wrong."))
}
