//
//  AuthService.swift
//  InventoryX
//
//  Created by Ryan Smetana on 3/18/24.
//

import SwiftUI
import CryptoKit

class AuthService {
    @Published var exists: Bool
    @Published var passHash: String = ""
    @Published var isLocked: Bool = false
    
    static let shared = AuthService()
    
    init() {
        self.exists = UserDefaults.standard.object(forKey: "passcode") != nil
        print("Passcode exists: \(exists)")
    }
    
    func hashString(_ str: String) -> String {
        let data = Data(str.utf8)
        let digest = SHA256.hash(data: data)
        let hash = digest.compactMap { String(format: "%02x", $0)}.joined()
        return hash
    }
    
    func savePasscode(hash: String) {
        UserDefaults.standard.setValue(hash, forKey: "passcode")
    }
    
    func checkPasscode(hash: String) -> Bool {
        let savedPasscode = getCurrentPasscode()
        return savedPasscode == hash
    }
    
    func getCurrentPasscode() -> String? {
        return UserDefaults.standard.value(forKey: "passcode") as? String
    }
}
