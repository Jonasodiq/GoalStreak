//
//  HomeListView.swift
//  GoalStreak
//
//  Created by Jonas Niyazson on 2025-05-01.
//

import SwiftUI
import FirebaseFirestore

struct HomeListView: View {
  @EnvironmentObject var goalViewModel: GoalViewModel
  @EnvironmentObject var authViewModel: AuthViewModel
  @EnvironmentObject var localizationManager: localizationManager
    
    var body: some View {
      NavigationStack {
        List {
          ForEach(goalViewModel.goals) { goal in
            HomeCellView(
                title: goal.name,
                subtitle: "",
                streak: 0,
                color: Color(hex: goal.colorHex) ?? .blue.opacity(0.2),
                icon: goal.emoji,
                destination: GoalProgressView(goal: goal)
            )
            .listRowBackground(Color.clear)
          }
          .onDelete(perform: delete)
        }
        .navigationTitle(localizationManager.localizedString(for: "habits_title"))
        .toolbar {
          ToolbarItem(placement: .navigationBarTrailing) {
            Button(action: {
              authViewModel.signOut()
              goalViewModel.clearGoals()
            }) {
                Image(systemName: "rectangle.portrait.and.arrow.forward")
                    .foregroundColor(.blue)
            }
          }
        }
      }
    }
  
  func delete(at offsets: IndexSet) {
    for index in offsets {
      let goal = goalViewModel.goals[index]
      goalViewModel.deleteGoal(goal)
    }
  }
}

#Preview() {
    HomeListView()
    .environmentObject(GoalViewModel())
    .environmentObject(localizationManager())
}
