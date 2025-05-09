//
//  AccountManagementView.swift
//  GoalStreak
//
//  Created by Jonas Niyazson on 2025-05-06.
//

import SwiftUI

struct AccountView: View {
  
  // MARK: - PROPERTIES
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var goalViewModel: GoalViewModel
    @Environment(\.dismiss) var dismiss

    @State private var currentPassword = ""
    @State private var newPassword = ""
    @State private var confirmNewPassword = ""
    @State private var passwordChangeError: String?
    @State private var deleteError: String?
    @State private var passwordForDeletion = ""

    var isChangingPassword: Bool

    var body: some View {
      ZStack {
        Form { if isChangingPassword {
            
          // MARK: Change password form
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
              if newPassword != confirmNewPassword {
                  passwordChangeError = "Lösenorden matchar inte."
              } else {
              authViewModel.changePassword(currentPassword: currentPassword, newPassword: newPassword) { error in
                  if let error = error {
                      passwordChangeError = error
                  } else {
                    passwordChangeError = nil
                    dismiss()
                  }
                }
              }
            }) {
                Text("Byt lösenord")
                  .fontWeight(.bold)
                  .padding()
                  .frame(maxWidth: .infinity)
                  .background(Color.blue)
                  .foregroundColor(.white)
                  .cornerRadius(10)
            }
            .padding()
          } //: - Section
          } else {
            // MARK: Delete account form
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
                authViewModel.deleteAccount(password: passwordForDeletion) { error in
                    if let error = error {
                        deleteError = error
                    } else {
                        deleteError = nil
                        dismiss()
                        goalViewModel.clearGoals()
                    }
                  }
                }) {
                    Text("Radera konto")
                      .fontWeight(.bold)
                      .padding()
                      .frame(maxWidth: .infinity)
                      .background(Color.red)
                      .foregroundColor(.white)
                      .cornerRadius(10)
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
