//
//  LoginView.swift
//  GoalStreak
//
//  Created by Jonas Niyazson on 2025-05-01.
//

import SwiftUI

struct LoginView: View {
  
  // MARK: - PROPERTIES
  @EnvironmentObject var authViewModel: AuthViewModel
  @EnvironmentObject var LM: LocalizationManager
  
  // MARK: - STATE
//  @State private var email = ""
//  @State private var password = ""
  @State private var isNewUser = false
  @State private var error: String?
  @State private var showInfo = false
  
  // Temporarily under development
  @State private var email: String = "test@test.com"
  @State private var password: String = "123456"
  
  var body: some View {
    ZStack(alignment: .topTrailing) {
      Image("desktop-blue")
        .resizable()
        .edgesIgnoringSafeArea(.all)
      
      VStack(alignment: .center, spacing: 32) {
        
        // MARK: - TITLE
        Image("GoalTitleBG")
          .resizable()
          .frame(width: 300, height: 200)
          .shadow(color: .black.opacity(0.4), radius: 24, x: 8, y: 18)
          .padding(.top, 60)
        
        // MARK: - Card
        VStack(spacing: 24) {
          Text(isNewUser ? LM.localizedString(for: "create_account") : LM.localizedString(for: "login"))
            .font(.largeTitle.bold())
            .foregroundColor(.blue)
          
          TextField(LM.localizedString(for: "email_ph"), text: $email)
            .textFieldStyle(.roundedBorder)
          
          SecureField(LM.localizedString(for: "password_ph"), text: $password)
            .textFieldStyle(.roundedBorder)
            .submitLabel(.go)
            .onSubmit {
              authenticateUser()
            }

          if let error = error {
            Text(error).foregroundColor(.red).font(.caption)
          }
          
          // MARK: - LOGIN BTN
          Button(isNewUser ? LM.localizedString(for: "account_btn") : LM.localizedString(for: "login_btn")) {
              authenticateUser()
            SoundPlayer.play("click")
          }
          .buttonStyle(.borderedProminent)
          .bold(true)
          .shadow(color: .black.opacity(0.3), radius: 8, x: 4, y: 8)
          
          Button(isNewUser ? LM.localizedString(for: "have_account") : LM.localizedString(for: "new_account")) {
            isNewUser.toggle()
            SoundPlayer.play("pop")
          }
          
        } //: - VStack
        .padding(24)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.4), radius: 24, x: 8, y: 18)
        .padding(.horizontal, 32)
      } //: - Big_VStack
      
      // MARK: - INFO BTN
      Button(action: {
        SoundPlayer.play("pop-in")
        showInfo = true
      }) {
          Image(systemName: "info.circle")
            .font(.title2)
            .padding()
            .foregroundColor(.white)
      }
      .padding(.top, 40)
      .padding(.trailing, 20)
    }//: - ZStack
    .alert(LM.localizedString(for: "info_title"), isPresented: $showInfo) {
        Button("OK", role: .cancel) {SoundPlayer.play("pop-up") }
    } message: {
        Text(LM.localizedString(for: "info_message"))
    }
  } //: - Body
  
  private func authenticateUser() {
      authViewModel.authenticate(email: email, password: password, isNewUser: isNewUser) {
        self.error = $0
      }
  }
}

// MARK: - PREVIEW
#Preview {
  LoginView()
    .environmentObject(AuthViewModel())
    .environmentObject(LocalizationManager())
}
