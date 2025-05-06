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
  // Referens till Firebase listener för inloggningsstatus
  private var handle: AuthStateDidChangeListenerHandle?
  
  // Startar lyssning på auth status
  init() {
      handle = Auth.auth().addStateDidChangeListener { _, user in
          self.user = user
      }
  }
    
  // Skapar konto om `isNewUser` är true, annars loggar in.
  func authenticate(email: String, password: String, isNewUser: Bool, completion: @escaping (String?) -> Void) {
      if isNewUser { // Skapa nytt konto
          Auth.auth().createUser(withEmail: email, password: password) { _, error in
              completion(error?.localizedDescription)
          }
      } else { // Logga in befintlig användare
          Auth.auth().signIn(withEmail: email, password: password) { _, error in
              completion(error?.localizedDescription)
          }
      }
  }
  
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
                  completion(nil) // lyckades
              }
          }
      }
  }
  
  func deleteAccount(completion: @escaping (Error?) -> Void) {
      guard let user = Auth.auth().currentUser else {
          completion(NSError(domain: "Auth", code: 401, userInfo: [NSLocalizedDescriptionKey: "Ingen användare inloggad"]))
          return
      }

      // Radera användardata i Firestore
      let db = Firestore.firestore()
      db.collection("users").document(user.uid).delete { error in
          if let error = error {
              completion(error)
              return
          }

          // Radera själva användarkontot
          user.delete { error in
              if let error = error {
                  completion(error)
              } else {
                  DispatchQueue.main.async {
                      self.user = nil
                  }
                  completion(nil)
              }
          }
      }
  }
  

  func deleteAccountWithReauth(password: String, completion: @escaping (String?) -> Void) {
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

  // Avsluta listener vid deinit
  deinit {
      if let handle = handle {
          Auth.auth().removeStateDidChangeListener(handle)
      }
  }
}
