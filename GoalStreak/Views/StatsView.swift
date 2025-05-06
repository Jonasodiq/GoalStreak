//
//  StatsView.swift
//  GoalStreak
//
//  Created by Jonas Niyazson on 2025-05-03.
//

import SwiftUI
import Charts

struct StatsView: View {
    @EnvironmentObject var goalViewModel: GoalViewModel
    @State private var weekData: [WeekData] = []
    var goal: Goal

    var body: some View {
      VStack(alignment: .leading) {
          Text("Veckostatistik")
              .font(.headline)

          if weekData.isEmpty {
              Text("Ingen data tillgänglig.")
                  .foregroundColor(.gray)
          } else {
              Chart(weekData) { day in
                  BarMark(
                      x: .value("Dag", day.day),
                      y: .value("Antal", day.count)
                  )
                  .foregroundStyle(.blue)
              }
              .frame(height: 200)
          }
      }
      .onAppear {
            if let id = goal.id {
                goalViewModel.fetchWeeklyData(for: id) { data in
                    weekData = data
                }
            }
        }
    }
}

extension Goal {
    static var preview: Goal {
        Goal(
            id: "test-id",
            name: "Testmål",
            description: "Ett testmål för att läsa 30 minuter.",
            group: "Hälsa",
            period: .dayLong,
            goalValue: 30,
            valueUnit: "min",
            streak: 3,
            lastCompletedDate: Date(),
            emoji: "🎯",
            colorHex: "#3498db",
            completionDates: [],
            userId: "preview-user"
        )
    }
}

#Preview {
    StatsView(goal: .preview)
        .environmentObject(GoalViewModel())
}



