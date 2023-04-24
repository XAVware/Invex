//
//  AlertManager.swift
//  XAV_Customs
//
//  © 2023 XAVware, LLC.
//
// ~~~~~~~~~~~~~~~ README ~~~~~~~~~~~~~~~
//

import SwiftUI

class AlertManager: ObservableObject {
    static let shared: AlertManager = AlertManager()
    @Published var isShowing: Bool = false
    var alert: Alert = Alert(title: Text(""))
    
    private init() { }
    
    func showError(title: String, message: String) {
        self.alert = Alert(title: Text(title), message: Text(message))
        self.isShowing.toggle()
    }
}
