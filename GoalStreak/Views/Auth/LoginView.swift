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
  @State private var email = ""
  @State private var password = ""
  @State private var isNewUser = false
  @State private var errorMessage: String?
  @State private var isLoading = false
  @FocusState private var focusedField: Field?
  
  enum Field {
    case email
    case password
  }
  
  var body: some View {
    
    ZStack {
      Color.green.opacity(0.2).edgesIgnoringSafeArea(.all)
      VStack(alignment: .center, spacing: 32) {
        
        Image(systemName: "person.badge.key")
          .resizable()
          .frame(width: 100, height: 100)
          .foregroundColor(.blue)
        
        
        // MARK: - Card
        VStack(spacing: 24) {
          VStack {
            Text(isNewUser ? "Sign Up" : "Sign In")
              .font(.largeTitle.bold())
              .foregroundColor(.blue)
            // MARK: - TextField
            TextField("Email", text: $email)
              .textFieldStyle(.roundedBorder)
              .keyboardType(.emailAddress)
              .autocapitalization(.none)
              .submitLabel(.next)
              .focused($focusedField, equals: .email)
              .onSubmit {
                focusedField = .password
              }
            
            SecureField("Password", text: $password)
              .textFieldStyle(.roundedBorder)
              .submitLabel(.go)
              .focused($focusedField, equals: .password)
              .onSubmit {
                authenticate()
              }
            
            if let error = errorMessage {
              Text(error)
                .foregroundColor(.red)
                .font(.footnote)
                .multilineTextAlignment(.center)
                .padding(.top, 5)
            }
            
            if isLoading {
              ProgressView().padding()
            }
          } //: - VStack
          
          // MARK: - BUTTONS
          VStack(spacing: 16) {
            Button(isNewUser ? "Skapa Konto" : "Logga In") {
              authenticate()
            }
            .primaryButton()
            .disabled(email.isEmpty || password.isEmpty)
            .opacity(email.isEmpty || password.isEmpty ? 0.5 : 1)
            
            Button(isNewUser ? "Redan användare? Logga in här" : "Ny användare? Skapa konto") {
              isNewUser.toggle()
              errorMessage = nil
            }
            .secondaryButton()
          } //: - VStack
        }  //: - VStack Card
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
        .shadow(radius: 4)
        .padding()
      } //: - VStack
    } //: - ZStack
  }
  
  func authenticate() {
    errorMessage = nil
    isLoading = true
    
    authViewModel.authenticate(email: email, password: password,
                               isNewUser: isNewUser) { error in
        finishAuth(error: error)
    }
    
    func finishAuth(error: String?) {
      DispatchQueue.main.async {
        self.isLoading = false
        self.errorMessage = error
        
        if error == nil {
          self.email = ""
          self.password = ""
        }
      }
    }
  }
}

// MARK: - PREVIEW
#Preview {
    LoginView()
    .environmentObject(AuthViewModel())
}
