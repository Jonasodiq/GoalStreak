//
//  AuthViewModel.swift
//  GoalStreak
//
//  Created by Jonas Niyazson on 2025-05-01.
//

import Foundation
import FirebaseAuth

class AuthViewModel: ObservableObject {
    @Published var user: User?
    private var handle: AuthStateDidChangeListenerHandle?

    init() {
        handle = Auth.auth().addStateDidChangeListener { _, user in
            self.user = user
        }
    }

    func authenticate(email: String, password: String, isNewUser: Bool, completion: @escaping (String?) -> Void) {
        if isNewUser {
            Auth.auth().createUser(withEmail: email, password: password) { _, error in
                completion(error?.localizedDescription)
            }
        } else {
            Auth.auth().signIn(withEmail: email, password: password) { _, error in
                completion(error?.localizedDescription)
            }
        }
    }

    func signOut() {
        try? Auth.auth().signOut()
    }

    deinit {
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
}

