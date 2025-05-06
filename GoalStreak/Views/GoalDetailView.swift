//
//  GoalDetailView.swift
//  GoalStreak
//
//  Created by Jonas Niyazson on 2025-05-02.
//

import SwiftUI
import Charts

struct GoalDetailView: View {
    @EnvironmentObject var goalViewModel: GoalViewModel
    @State private var goalLogs: [GoalLog] = []
    var goal: Goal

    var body: some View {
        let weekData = generateWeekData(from: goalLogs)
    
        VStack(alignment: .center, spacing: 20) {
          
          Divider().background(.blue)
          
            Text("Streak: \(goal.streak) dagar i rad")
                .font(.title2)
          
          Divider().background(.blue)
          
            Text("Senast utförd: \(goal.lastCompletedDate.map { Self.dateFormatter.string(from: $0) } ?? "Aldrig")")
                .font(.title3)

          Divider().background(.blue)
          
            Button(action: {
                goalViewModel.markGoalCompleted(goal: goal)
            }) {
                Text("Markera som utförd idag")
                  .padding()
                  .frame(maxWidth: .infinity)
                  .background(isMarkedToday ? Color.gray : Color.green)
                  .foregroundColor(.white)
                  .cornerRadius(10)
            }
            .disabled(isMarkedToday)

            Divider()

            Text("📊 Denna vecka").font(.headline)

            if weekData.isEmpty {
                Text("Ingen statistik ännu")
                    .foregroundColor(.secondary)
            } else {
                Chart(weekData) { day in
                    BarMark(
                        x: .value("Dag", day.day),
                        y: .value("Antal", day.count)
                    )
                    .annotation(position: .overlay) {
                        Text("\(day.count)")
                            .foregroundStyle(.orange)
                    }
                    .foregroundStyle(.blue.gradient)
                }
                .frame(height: 200)
                .chartYScale(range: .plotDimension(padding: 10))
                .padding(.bottom)
            }

          Divider()

            Spacer()
        }
        .padding()
        .navigationTitle(goal.name)
        .onAppear {
            goalViewModel.fetchLogs(for: goal.id ?? "") { logs in
              self.goalLogs = logs
              for log in logs {
                         print("Log timestamp: \(log.timestamp)")
                     }
            }
        }
    }

    private var isMarkedToday: Bool {
        guard let lastDate = goal.lastCompletedDate else { return false }
        return Calendar.current.isDateInToday(lastDate)
    }

  private func generateWeekData(from logs: [GoalLog]) -> [WeekData] {
      let calendar = Calendar.current
      let today = Date()
      guard let weekStart = calendar.dateInterval(of: .weekOfYear, for: today)?.start else { return [] }

      let formatter = DateFormatter()
      formatter.locale = Locale(identifier: "en_US_POSIX")
      formatter.dateFormat = "E"

      return (0..<7).compactMap { offset in
        guard let date = calendar.date(byAdding: .day, value: offset, to: weekStart),
              let localDate = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: date) else { return nil }


        let count = logs.filter {
            calendar.isDate($0.timestamp, inSameDayAs: localDate)
        }.count

        let dayString = formatter.string(from: localDate)

        return WeekData(day: dayString, date: localDate, count: count)

      }
  }

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
}

// MARK: - PREVIEW
#Preview() {
    GoalDetailView(goal: Goal(
        id: "123",
        name: "Läsa bok",
        description: "Läs minst 30 minuter varje dag",
        group: "Personlig utveckling",
        period: .dayLong,
        goalValue: 30,
        valueUnit: "min",
        streak: 5,
        lastCompletedDate: Date(),
        emoji: "📚",
        colorHex: "#4CAF50",
        completionDates: [],
        userId: "123"
    ))
    .environmentObject(GoalViewModel())
}
