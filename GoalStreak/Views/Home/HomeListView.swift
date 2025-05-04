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
  @EnvironmentObject var localizationManager: LocalizationManager
    
    var body: some View {
      NavigationStack {
        List {
            ForEach(goalViewModel.goals) { goal in
                HomeCellView(
                    title: goal.name,
                    color: Color(hex: goal.colorHex) ?? .blue.opacity(0.2),
                    icon: goal.emoji,
                    destination: GoalDetailView(goal: goal)
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

#Preview("Light Mode") {
    HomeListView()
    .environmentObject(GoalViewModel())
    .environmentObject(LocalizationManager())
}
#Preview("Dark Mode") {
    HomeListView()
    .environmentObject(GoalViewModel())
    .environmentObject(LocalizationManager())
    .preferredColorScheme(.dark)
}
