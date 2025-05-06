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

    var body: some View {
        VStack(spacing: 20) {
          Text("\(goal.streak) dagar i rad")
            .font(.title2)
          HStack {
            Text(goal.emoji)
              .font(.largeTitle)
          }

            if let description = goal.description {
                Text(description)
                    .font(.caption)
            }

          TimerView(goal: goal, minutes: 2)
        }
        .padding()
        .navigationTitle(goal.name)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                  Button {
                      showEditSheet = true
                  } label: {
                    Label("Redigera", systemImage: "pencil")
                  }

                  Button(role: .destructive) {
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
            GoalEditView(goal: goal)
                .environmentObject(goalViewModel)
        }
    }
}


struct GoalProgressView_Previews: PreviewProvider {
    static var previews: some View {
        let previewGoal = Goal(
            id: "demo123",
            name: "Read Book",
            description: "Läs minst 20 minuter varje kväll",
            group: "Health",
            period: .dayLong,
            goalValue: 1.0,
            valueUnit: "ggr",
            streak: 7,
            lastCompletedDate: Date(),
            emoji: "📖",
            colorHex: "#007AFF",
            completionDates: [Date()],
            userId: "user_abc"
        )
        return GoalProgressView(goal: previewGoal)
    }
}
