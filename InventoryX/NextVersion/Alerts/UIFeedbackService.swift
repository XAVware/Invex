//
//  TaskFeedbackService.swift
//  VerbalFluency
//
//  Created by Ryan Smetana on 3/13/24.
//

import SwiftUI

@MainActor class UIFeedbackService: ObservableObject {
    @Published var alert: AlertModel?
    @Published var isLoading: Bool = false
    
    static let shared = UIFeedbackService()
    
    func showAlert(_ type: AlertModel.AlertType, _ message: String) {
        self.alert = AlertModel(type: type, message: message)
    }
    
    func removeAlert() {
        self.alert = nil
    }
    
    func startLoading() {
        self.isLoading = true
    }
    
    func stopLoading() {
        self.isLoading = false
    }
}
