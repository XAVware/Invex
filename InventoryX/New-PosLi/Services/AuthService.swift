//
//  AuthService.swift
//  InventoryX
//
//  Created by Ryan Smetana on 3/18/24.
//

import SwiftUI
import CryptoKit

class AuthService {
    static let shared = AuthService()
    
    @AppStorage("passcode", store: .standard) var passcode: String = ""
    
    func hashString(_ str: String) -> String {
        let data = Data(str.utf8)
        let digest = SHA256.hash(data: data)
        let hash = digest.compactMap { String(format: "%02x", $0)}.joined()
        return hash
    }
}
