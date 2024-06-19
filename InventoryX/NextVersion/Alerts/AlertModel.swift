//
//  AlertModel.swift
//  VerbalFluency
//
//  Created by Ryan Smetana on 12/29/23.
//

import SwiftUI


struct AlertModel: Equatable {
    enum AlertType { case error, success }
    let type: AlertType
    let message: String
    
    var title: String {
        return switch self.type {
        case .error:    "Error"
        case .success:  "Success"
        }
    }
    
    var iconName: String {
        return switch self.type {
        case .error:    "exclamationmark.triangle.fill"
        case .success:  "checkmark.circle"
        }
    }
    
    var bgColor: Color {
        return switch self.type {
        case .error:    Color("ErrorAlertColor")
        case .success:  Color("SuccessAlertColor")
        }
    }
}
