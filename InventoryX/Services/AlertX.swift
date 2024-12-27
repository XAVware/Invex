//
//  AlertView.swift
//  InventoryX
//
//  Created by Ryan Smetana on 12/31/23.
//

// MARK: - Alert Model
//struct AlertModel: Equatable {
//    enum AlertType { case error, success }
//    let type: AlertType
//    let message: String
//    
//    var title: String {
//        return switch self.type {
//        case .error:    "Error"
//        case .success:  "Success"
//        }
//    }
//    
//    var iconName: String {
//        return switch self.type {
//        case .error:    "exclamationmark.triangle.fill"
//        case .success:  "checkmark.circle"
//        }
//    }
//    
//    var bgColor: Color {
//        return switch self.type {
//        case .error:    Color.alertError
//        case .success:  Color.alertSuccess
//        }
//    }
//}


// MARK: - Alert Service
//@Observable
//class AlertService {
//    var alert: AlertModel?
//    var isLoading: Bool = false
//    
//    static let shared = AlertService()
//    
//    private init() { }
//    
//    func showAlert(_ type: AlertModel.AlertType, _ message: String) {
//        self.alert = AlertModel(type: type, message: message)
//    }
//    
//    func removeAlert() {
//        self.alert = nil
//    }
//}

import SwiftUI

// MARK: - Alert Model
struct AlertModel: Equatable {
    enum AlertType { case error, success }
    let type: AlertType
    let message: String
    
    var title: String {
        switch self.type {
        case .error:    "Error"
        case .success:  "Success"
        }
    }
    
    var iconName: String {
        switch self.type {
        case .error:    "exclamationmark.triangle.fill"
        case .success:  "checkmark.circle"
        }
    }
    
    var bgColor: Color {
        switch self.type {
        case .error:    Color.alertError
        case .success:  Color.alertSuccess
        }
    }
}

// MARK: - Alert Service
@Observable
class AlertService {
    static let shared = AlertService()
    private init() { }
    
    var currentAlert: AlertModel?
    var isLoading: Bool = false
    
    func show(type: AlertModel.AlertType, message: String) {
        currentAlert = AlertModel(type: type, message: message)
    }
    
    func dismiss() {
        currentAlert = nil
    }
}

// MARK: - Alert View
struct AlertView: View {
    @Environment(AlertService.self) var alertService
    
    @State private var offset: CGFloat = -100
    @State private var opacity: CGFloat = 0
    
    private var lineCount: Int {
        guard let message = alertService.currentAlert?.message else { return 1 }
        switch message.count {
        case 0...26: return 1
        case 27...52: return 2
        default: return 3
        }
    }
    
    private var alertPadding: CGFloat {
        CGFloat(8 * lineCount)
    }
    
    private func close() {
        withAnimation(.easeIn(duration: 0.1)) {
            opacity = 0
            offset = -100
        }
        
        Task { @MainActor in
            try? await Task.sleep(for: .milliseconds(150))
            alertService.dismiss()
        }
    }
    
    var body: some View {
        VStack {
            if let alert = alertService.currentAlert {
                alertContent(alert)
                    .onAppear {
                        withAnimation(.bouncy(duration: 0.1, extraBounce: 0.08)) {
                            opacity = 1
                            offset = 0
                        }
                    }
                    .onTapGesture(perform: close)
                    .task {
                        try? await Task.sleep(for: .seconds(3))
                        await MainActor.run {
                            close()
                        }
                    }
            }
            Spacer()
        }
    }
    
    @ViewBuilder
    private func alertContent(_ alert: AlertModel) -> some View {
        HStack {
            Image(systemName: alert.iconName)
                .padding()
                .font(.title2)

            VStack(alignment: .leading, spacing: 2) {
                Text(alert.title)
                    .font(.caption)
                Text(alert.message)
                    .font(.subheadline)
                    .fontWeight(.semibold)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Image(systemName: "xmark")
                .resizable()
                .scaledToFit()
                .frame(width: 10)
                .padding(.horizontal)
        }
        .foregroundStyle(Color.textLight)
        .frame(maxWidth: 400, maxHeight: 56 + alertPadding)
        .background {
            alert.bgColor
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .shadow(radius: 6)
        }
        .gesture(
            DragGesture()
                .onChanged { value in
                    if value.translation.height < 0 {
                        close()
                    }
                }
        )
        .padding()
        .offset(y: offset)
        .opacity(opacity)
    }
}


#Preview {
    AlertView()
        .onAppear {
            AlertService.shared.show(type: .error, message: "Test")
        }
        .environment(AlertService.shared)
}
