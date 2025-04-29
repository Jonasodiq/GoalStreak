//
//  ContentView.swift
//  GoalStreak
//
//  Created by Jonas Niyazson on 2025-04-29.
//

import SwiftUI
import Firebase

struct ContentView: View {
  // MARK: - PROPERTIES
  @State var viewModel = GoalViewModel()
  @State private var newGoal = ""
  
    var body: some View {
      NavigationView {
        VStack {
          HStack {
            TextField("Nytt mål...", text: $newGoal)
              .textFieldStyle(RoundedBorderTextFieldStyle())
              .padding(.leading)
            
            Button(action: {
              guard !newGoal.isEmpty else { return }
              viewModel.addGoal(name: newGoal)
              newGoal = ""
            }) {
              Image(systemName: "plus.circle.fill")
                .foregroundColor(.blue)
                .font(.title)
            }
            .padding()
          } //: - VStack
        } //: - HStack End
      }  //: - Nav
    } //: - Body
}

// MARK: - PREVIEW
#Preview {
    ContentView()
}
