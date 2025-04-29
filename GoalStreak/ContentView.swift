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
        ZStack {
          Color.blue.opacity(0.1).ignoresSafeArea()
          
          VStack(alignment: .leading, spacing: 8) {
            Text("Lägg till Mål")
              .font(.title2.bold())
              .padding(.horizontal)
              .foregroundColor(.blue)
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
            } //: - HStack
            List(viewModel.goals) { goal in
              Button(action: {
                viewModel.completeGoal(goal)
              }) {
                HStack {
                  VStack(alignment: .leading) {
                    Text(goal.name)
                      .font(.headline)
                    
                    Text("Streak: \(goal.streak)")
                      .font(.subheadline)
                      .foregroundColor(.gray)
                  }
                  
                  Spacer()
                  
                  Text(viewModel.formattedDate(goal.lastCompletedDate))
                    .font(.caption)
                    .foregroundColor(.secondary)
                }
              }
            }
          }//: - VStack
          .padding(.top)
          .listStyle(.plain)
        }
      }  //: - Nav
      .navigationTitle("Dina mål")
    } //: - Body
}

// MARK: - PREVIEW
#Preview {
    ContentView()
}
