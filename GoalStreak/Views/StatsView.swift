//
//  StatsView.swift
//  GoalStreak
//
//  Created by Jonas Niyazson on 2025-07-27.
//

import SwiftUI

struct StatsView: View {
    @EnvironmentObject var goalViewModel: GoalViewModel
    @State private var selectedGoal: Goal?

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                Text("Välj ett mål")
                    .font(.headline)
                    .padding(.top)

                if goalViewModel.goals.isEmpty {
                    Text("Inga mål tillgängliga.")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    Picker("Mål", selection: $selectedGoal) {
                        ForEach(goalViewModel.goals) { goal in
                            Text("\(goal.emoji) \(goal.name)").tag(Optional(goal)) // Optional-tag krävs
                        }
                    }
                    .pickerStyle(.wheel) // Eller .inline för meny-stil
                    .frame(height: 100)
                    .clipped()

                    if let selected = selectedGoal {
                        Divider()
                        CalendarView(goal: selected)
                            .environmentObject(goalViewModel)
                            .frame(maxHeight: .infinity)
                    } else {
                        Text("Välj ett mål ovan för att se statistik.")
                            .foregroundColor(.secondary)
                            .padding()
                    }
                }

                Spacer()
            }
            .padding()
            .navigationTitle("Statistik")
            .onAppear {
                if selectedGoal == nil {
                    selectedGoal = goalViewModel.goals.first
                }
            }
        }
    }
}

#Preview {
    StatsView()
        .environmentObject(GoalViewModel())
}

