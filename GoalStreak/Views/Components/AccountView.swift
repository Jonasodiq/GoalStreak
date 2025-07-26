//
//  AccountManagementView.swift
//  GoalStreak
//
//  Created by Jonas Niyazson on 2025-05-06.
//

import SwiftUI

struct AccountView: View {
  
    // MARK: - Environment
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var goalViewModel: GoalViewModel
    @Environment(\.dismiss) var dismiss
  
    // MARK: - STATE
    @State private var currentPassword = ""
    @State private var newPassword = ""
    @State private var confirmNewPassword = ""
    @State private var passwordChangeError: String?
    @State private var deleteError: String?
    @State private var passwordForDeletion = ""
    @State private var showDeleteConfirmation = false

    var isChangingPassword: Bool

    var body: some View {
      ZStack {
        Form { if isChangingPassword {
            
          // MARK: Change password
          Section(header: Text("Byt lösenord").font(.headline).foregroundColor(.blue)) {
            VStack(alignment: .leading, spacing: 0) {
              SecureField("Nuvarande lösenord", text: $currentPassword)
              .textFieldStyle(RoundedBorderTextFieldStyle())
              .padding()
              .autocapitalization(.none)
              
              SecureField("Nytt lösenord", text: $newPassword)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
                .autocapitalization(.none)
              
              SecureField("Bekräfta nytt lösenord", text: $confirmNewPassword)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .autocapitalization(.none)
            } //: - VStack
              
            if let error = passwordChangeError {
              Text(error)
                .foregroundColor(.red)
                .padding(.horizontal)
            }
            
            // MARK: - Change BTN
            Button(action: {
                guard validatePasswordChange() else { return }

                SoundPlayer.play("pop")
                authViewModel.changePassword(currentPassword: currentPassword, newPassword: newPassword) { error in
                    if let error = error {
                        SoundPlayer.play("error")
                        passwordChangeError = error
                    } else {
                        SoundPlayer.play("success")
                        dismiss()
                    }
                }
            }) {
                Text("Byt lösenord")
                    .primaryButtonStyle(backgroundColor: .blue)
                    .padding()
            }
          } //: - Section
          } else {
            
            // MARK: Delete account
            Section(header: Text("Radera konto").font(.headline).foregroundColor(.red)) {
                SecureField("Lösenord för radering", text: $passwordForDeletion)
                  .textFieldStyle(RoundedBorderTextFieldStyle())
                  .padding()
                  .autocapitalization(.none)
                
                if let error = deleteError {
                    Text(error)
                      .foregroundColor(.red)
                      .padding(.horizontal)
                }
              
              // MARK: - Delete BTN
              Button(action: {
                  guard validateAccountDeletion() else { return }
                  showDeleteConfirmation = true // Visa bekräftelse-alert
              }) {
                  Text("Radera konto")
                      .primaryButtonStyle(backgroundColor: .red)
                      .padding()
              }
              .alert("Är du säker?", isPresented: $showDeleteConfirmation) {
                  Button("Radera", role: .destructive) {
                      SoundPlayer.play("pop")
                      authViewModel.deleteAccount(password: passwordForDeletion) { error in
                          if let error = error {
                              SoundPlayer.play("error")
                              deleteError = error
                          } else {
                              SoundPlayer.play("success")
                              dismiss()
                              goalViewModel.clearGoals()
                          }
                      }
                  }
                  Button("Avbryt", role: .cancel) { }
              } message: {
                  Text("Detta går inte att ångra.")
              }

              .padding()
            }
          } //: - If sats
        } //: - Form
        .navigationTitle("Hantera konto")
        .navigationBarItems(trailing: Button(action: {
            dismiss()
        }) {
            Text("Avbryt")
              .foregroundColor(.gray)
        })
        .padding(.top)
      } //: - ZStack
    }
  
    private func validatePasswordChange() -> Bool {
        if currentPassword.isEmpty || newPassword.isEmpty || confirmNewPassword.isEmpty {
            SoundPlayer.play("error")
            passwordChangeError = "Fyll i alla fält."
            return false
        }
        
        if newPassword != confirmNewPassword {
            SoundPlayer.play("error")
            passwordChangeError = "Lösenorden matchar inte."
            return false
        }
        return true
    }
  
    private func validateAccountDeletion() -> Bool {
        if passwordForDeletion.isEmpty {
            SoundPlayer.play("error")
            deleteError = "Fyll i lösenordet för att radera kontot."
            return false
        }
        return true
    }


}

// MARK: - PREVIEW
#Preview("Change password") {
    AccountView(isChangingPassword: true)
        .environmentObject(AuthViewModel())
        .environmentObject(GoalViewModel())
}
#Preview("Delete account") {
  AccountView(isChangingPassword: false)
        .environmentObject(AuthViewModel())
        .environmentObject(GoalViewModel())
}
