//
//  AuthViewModel.swift
//  GoalStreak
//
//  Created by Jonas Niyazson on 2025-05-01.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import Combine

class AuthViewModel: ObservableObject {
    
    // MARK: - Public
    @Published var user: User?
    @Published var authErrorMessage: String?
    
    // MARK: - Private
    private var handle: AuthStateDidChangeListenerHandle?

    // MARK: - Init
    init() {
        handle = Auth.auth().addStateDidChangeListener { _, user in
            DispatchQueue.main.async {
                self.user = user
            }
        }
    }

    // MARK: - Autentisering (Inloggning / Registrering)
    func authenticate(email: String, password: String, isNewUser: Bool, completion: @escaping (String?) -> Void) {
        guard !email.isEmpty, !password.isEmpty else {
            completion("E-post och lösenord får inte vara tomma.")
            return
        }

        if isNewUser {
            Auth.auth().createUser(withEmail: email, password: password) { result, error in
                if let error = error {
                    completion("Registrering misslyckades: \(error.localizedDescription)")
                } else {
                    completion(nil)
                }
            }
        } else {
            Auth.auth().signIn(withEmail: email, password: password) { result, error in
                if let error = error {
                    completion("Inloggning misslyckades: \(error.localizedDescription)")
                } else {
                    completion(nil)
                }
            }
        }
    }

    // MARK: - Byt lösenord
    func changePassword(currentPassword: String, newPassword: String, completion: @escaping (String?) -> Void) {
        guard let user = Auth.auth().currentUser,
              let email = user.email else {
            completion("Ingen inloggad användare.")
            return
        }

        let credential = EmailAuthProvider.credential(withEmail: email, password: currentPassword)

        user.reauthenticate(with: credential) { _, error in
            if let error = error {
                completion("Fel nuvarande lösenord: \(error.localizedDescription)")
                return
            }

            user.updatePassword(to: newPassword) { error in
                if let error = error {
                    completion("Kunde inte uppdatera lösenord: \(error.localizedDescription)")
                } else {
                    completion(nil)
                }
            }
        }
    }

    // MARK: - Radera konto
    func deleteAccount(password: String, completion: @escaping (String?) -> Void) {
        guard let user = Auth.auth().currentUser,
              let email = user.email else {
            completion("Ingen inloggad användare.")
            return
        }

        let credential = EmailAuthProvider.credential(withEmail: email, password: password)

        user.reauthenticate(with: credential) { _, error in
            if let error = error as NSError? {
                if error.code == AuthErrorCode.wrongPassword.rawValue {
                    completion("Fel lösenord. Försök igen.")
                } else {
                    completion("Återautentisering misslyckades: \(error.localizedDescription)")
                }
                return
            }

            user.delete { error in
                if let error = error {
                    completion("Kunde inte radera konto: \(error.localizedDescription)")
                } else {
                    DispatchQueue.main.async {
                        self.user = nil
                    }
                    completion(nil)
                }
            }
        }
    }

    // MARK: - Logga ut
    func signOut() {
        do {
            try Auth.auth().signOut() 
            user = nil
        } catch {
            authErrorMessage = "Kunde inte logga ut: \(error.localizedDescription)"
        }
    }

    // MARK: - Deinit
    deinit {
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
}

