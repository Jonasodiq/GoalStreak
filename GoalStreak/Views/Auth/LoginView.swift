//
//  LoginView.swift
//  GoalStreak
//
//  Created by Jonas Niyazson on 2025-05-01.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var email = ""
    @State private var password = ""
    @State private var isNewUser = false
    @State private var error: String?

    var body: some View {
        VStack(spacing: 20) {
            Text(isNewUser ? "Skapa konto" : "Logga in")
                .font(.largeTitle.bold())

            TextField("E-post", text: $email)
                .textFieldStyle(.roundedBorder)

            SecureField("Lösenord", text: $password)
                .textFieldStyle(.roundedBorder)

            if let error = error {
                Text(error).foregroundColor(.red).font(.caption)
            }

            Button(isNewUser ? "Skapa konto" : "Logga in") {
                authViewModel.authenticate(email: email, password: password, isNewUser: isNewUser) {
                    self.error = $0
                }
            }
            .buttonStyle(.borderedProminent)

            Button(isNewUser ? "Har redan konto?" : "Skapa nytt konto") {
                isNewUser.toggle()
            }
        }
        .padding()
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthViewModel())
}

