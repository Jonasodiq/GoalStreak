//
//  AuthViewModel.swift
//  GoalStreak
//
//  Created by Jonas Niyazson on 2025-05-01.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class AuthViewModel: ObservableObject {
  @Published var user: User?
  // Reference to Firebase listener for login status
  private var handle: AuthStateDidChangeListenerHandle?
  
  // Starts listening on auth status
  init() {
      handle = Auth.auth().addStateDidChangeListener { _, user in
          self.user = user
      }
  }
    
  // Creates account & login
  func authenticate(email: String, password: String, isNewUser: Bool, completion: @escaping (String?) -> Void) {
      if isNewUser { // A new account
          Auth.auth().createUser(withEmail: email, password: password) { _, error in
              completion(error?.localizedDescription)
          }
      } else { // login
          Auth.auth().signIn(withEmail: email, password: password) { _, error in
              completion(error?.localizedDescription)
          }
      }
  }
  
  // Change password
  func changePassword(currentPassword: String, newPassword: String, completion: @escaping (String?) -> Void) {
      guard let user = Auth.auth().currentUser,
            let email = user.email else {
          completion("Ingen inloggad användare.")
          return
      }

      let credential = EmailAuthProvider.credential(withEmail: email, password: currentPassword)
      user.reauthenticate(with: credential) { _, error in
          if let error = error {
              completion("Återautentisering misslyckades: \(error.localizedDescription)")
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
  
  // Delete account
  func deleteAccount(password: String, completion: @escaping (String?) -> Void) {
      guard let user = Auth.auth().currentUser,
            let email = user.email else {
          completion("Ingen inloggad användare.")
          return
      }

      let credential = EmailAuthProvider.credential(withEmail: email, password: password)

      user.reauthenticate(with: credential) { _, error in
          if let error = error {
              completion("Återautentisering misslyckades: \(error.localizedDescription)")
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

  func signOut() {
      try? Auth.auth().signOut()
  }

  // Terminate listener on deinit
  deinit {
      if let handle = handle {
          Auth.auth().removeStateDidChangeListener(handle)
      }
  }
}
