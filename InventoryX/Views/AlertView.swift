//
//  AlertView.swift
//  VerbalFluency
//
//  Created by Ryan Smetana on 12/31/23.
//

import SwiftUI
import Combine

@MainActor class AlertViewModel: ObservableObject {
    private let service = UIFeedbackService.shared
    private var cancellables = Set<AnyCancellable>()
    
    @Published var alert: AlertModel? = nil
    
    init() {
        configureSubscribers()
    }
    
    func configureSubscribers() {
        service.$alert
            .sink { [weak self] alert in
                debugPrint("Alert received")
                Task { 
                    
                    self?.alert = alert
                    
                }
            }
            .store(in: &cancellables)
    }
}

struct AlertView: View {
    @StateObject var vm: AlertViewModel = AlertViewModel()
//    @State var alert: AlertModel
    
    @State private var offset: CGFloat = -100
    @State private var opacity: CGFloat = 0
    @State private var showingAlert: Bool = false
    
    private var lineCount: Int {
        var tempCount = 1
        let messageLength = vm.alert?.message.count ?? 1
        
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
        VStack {
            if let alert = vm.alert {
                
                alertView
                .onAppear {
                    debugPrint(">>> ALERT: \(String(describing: alert.message))")
                    withAnimation(.bouncy(duration: 0.1, extraBounce: 0.08)) {
                        opacity = 1
                        offset = 0
                    }
                }
                .onReceive(vm.$alert, perform: { alert in
                    if alert != nil {
                        showingAlert = true
                    } else {
                        showingAlert = false
                    }
//                    debugPrint("View received alert: \(alert)")
                })
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
            }
            Spacer()
        } //: VStack
        
    } //: Body
    
    @ViewBuilder private var alertView: some View {
        if let alert = vm.alert {
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
            .padding(.vertical)
            .offset(y: offset)
            .opacity(opacity)
        }
    }
//    private var viewBackground: some View {
//        alert.bgColor
//            .clipShape(RoundedRectangle(cornerRadius: 8))
//            .shadow(radius: 6)
//    } //: View Background
    
    
}


//#Preview {
//    AlertView(alert: AlertModel(type: .error, message: "Uh oh! Something went wrong."))
//}


#Preview {
    AlertView()
        .onAppear {
            UIFeedbackService.shared.showAlert(.error, "Test")
        }
//    DepartmentDetailView(department: DepartmentEntity())
}
