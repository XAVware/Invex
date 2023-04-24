////
////  UserManager.swift
////  uParker-SwiftUI
////
////  Created by Ryan Smetana on 4/23/23.
////
//
//import SwiftUI
//import Firebase
//import FirebaseFirestore
//
//class UserManager: ObservableObject {
//    @Published var isLoggedIn: Bool = false
//
//    static let shared = UserManager()
//    let auth = Auth.auth()
//
//    var user: User?
//
//    private init() {
//        if auth.currentUser != nil {
//            getCurrentUser {
//                self.signIn()
//            }
//        }
//    }
//
//    func getCurrentUser(completion: @escaping () -> ()) {
//        guard let user = auth.currentUser else { return }
//
//        let userRef = Firestore.firestore().collection("users").document(user.uid)
//
//        userRef.getDocument { snapshot, error in
//            if let error = error {
//                print(error)
//                return
//            }
//
//            guard let data = snapshot?.data() else {
//                print("No Snapshot")
//                return
//
//            }
//
//            self.user = User.initFrom(data)
//            completion()
//        }
//    }
//
//    func signIn() {
//        guard user != nil else {
//            print("Tried logging in but user is nil")
//            return
//        }
//        isLoggedIn = true
//    }
//
//    func signOut() {
//        do {
//            try auth.signOut()
//            user = nil
//            isLoggedIn = false
//        } catch {
//            print("Error Signing Out: \(error.localizedDescription)")
//        }
//    }
//}
