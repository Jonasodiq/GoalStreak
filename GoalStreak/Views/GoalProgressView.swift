//
//  GoalProgressView.swift
//  GoalStreak
//
//  Created by Jonas Niyazson on 2025-05-05.
//

import SwiftUI

struct GoalProgressView: View {
    let goal: Goal
    @EnvironmentObject var goalViewModel: GoalViewModel
    @Environment(\.presentationMode) var presentationMode

    @State private var showEditSheet = false

    // MARK: - BODY
    var body: some View {
      ZStack {
        Color(hex: goal.colorHex).opacity(0.1).edgesIgnoringSafeArea(.all)
        VStack(spacing: 20) {
          
          Text("\(goal.streak) dagar Streak")
            .font(.title2)
          
          Text(goal.emoji)
            .font(.system(size: 64, weight: .bold, design: .default))
          
          if let description = goal.description {
            Text(description)
              .font(.caption)
          }
          
          TimerView(goal: goal)
          
        }
        .padding()
        .navigationTitle(goal.name)
        .toolbar { // MARK: - Edit/Delete BTN
          ToolbarItem(placement: .navigationBarTrailing) {
            Menu {
              Button { // Edit
                SoundPlayer.play("pop")
                showEditSheet = true
              } label: {
                Label("Redigera", systemImage: "pencil")
              }
              // Delete
              Button(role: .destructive) {
                SoundPlayer.play("vand-blad-1")
                goalViewModel.deleteGoal(goal)
                presentationMode.wrappedValue.dismiss()
              } label: {
                Label("Radera", systemImage: "trash")
              }
            } label: {
              Image(systemName: "ellipsis.circle")
                .imageScale(.large)
                .foregroundColor(.primary)
            }
          }
        }
        .sheet(isPresented: $showEditSheet) {
          GoalFormView(
            mode: .edit(goal),
            selectedTab: .constant(0)
          )
          .environmentObject(goalViewModel)
          .environmentObject(LocalizationManager())
        }
      }
    }
}

// MARK: - PREVIEW
#Preview {
    let previewGoal = Goal(
        id: "demo123",
        name: "Read Book",
        description: "Läs minst 20 minuter varje kväll",
        period: .dayLong,
        goalValue: 20.0,
        valueUnit: "min",
        streak: 7,
        lastCompletedDate: Date(),
        emoji: "📖",
        colorHex: "#007AFF",
        userId: "user_abc"
    )
    return GoalProgressView(goal: previewGoal)
}

