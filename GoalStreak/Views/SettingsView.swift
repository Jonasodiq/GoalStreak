//
//  SettingsView.swift
//  GoalStreak
//
//  Created by Jonas Niyazson on 2025-05-03.
//

import SwiftUI

struct SettingsView: View {
  @EnvironmentObject var authViewModel: AuthViewModel
  
    var body: some View {
        NavigationStack {
          List {
              Section(header: Text("Konto")) {
                  Button() {
                      authViewModel.signOut()
                  } label: {
                      Label("Logga ut", systemImage: "arrow.backward.circle")
                  }
              }

              Section(header: Text("Om Appen")) {
                  Label("Version 1.0", systemImage: "info.circle")
              }
          }
          .navigationTitle("Settings")
        }
    }
}


#Preview {
    SettingsView()
}
