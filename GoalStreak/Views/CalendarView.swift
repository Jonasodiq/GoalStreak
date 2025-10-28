//
//  CalendarView.swift
//  GoalStreak
//
//  Created by Jonas Niyazson on 2025-07-27.
//

import SwiftUI

struct CalendarDay: Identifiable {
    let id = UUID()
    let date: Date
    let completedValue: Double
    let goalValue: Double
    
    var isCompleted: Bool { completedValue >= goalValue }
    
    var progress: Double {
        guard goalValue > 0 else { return 0 }
        return min(completedValue / goalValue, 1.0)
    }
}

struct CalendarView: View {
    let goal: Goal
    @EnvironmentObject var goalViewModel: GoalViewModel

    @State private var currentMonth: Date = Date()
    @State private var daysInMonth: [CalendarDay] = []

    var body: some View {
        VStack {
            // Månadsväljare
            HStack {
                Button(action: {
                    changeMonth(by: -1)
                }) {
                    Image(systemName: "chevron.left")
                }

                Spacer()
                Text(currentMonthFormatted)
                    .font(.title2.bold())
                Spacer()

                Button(action: {
                    changeMonth(by: 1)
                }) {
                    Image(systemName: "chevron.right")
                }
            }
            .padding()

            // Veckodagar
            HStack {
                ForEach(["Mån", "Tis", "Ons", "Tor", "Fre", "Lör", "Sön"], id: \.self) { day in
                    Text(day)
                        .frame(maxWidth: .infinity)
                        .font(.caption)
                }
            }

            // Kalender
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 8) {
                ForEach(daysInMonth) { day in
                  let isCurrentMonth = Calendar.current.isDate(day.date, equalTo: currentMonth, toGranularity: .month)
                  let dayNumber = Calendar.current.component(.day, from: day.date)
                  let isToday = Calendar.current.isDate(day.date, inSameDayAs: Date())

                  ZStack {
                      // Bakgrundscirkel (grå)
                      Circle()
                          .stroke(
                            Color.gray.opacity(0.1), lineWidth: 4
                          )

                      // Progressring (grön)
                    if day.progress > 0 {
                          Circle()
                              .trim(from: 0, to: min(day.progress, 1.0))
                              .stroke(Color.green, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                              .rotationEffect(.degrees(-90))
                              .animation(.easeInOut, value: day.progress)
                      }

                      // Text med eventuell bakgrund
                      Text("\(dayNumber)")
                          .font(.caption.bold())
                          .foregroundColor(isToday ? .white : (isCurrentMonth ? .primary : .gray))
                          .frame(width: 30, height: 30)
                          .background(
                              Circle()
                                  .foregroundColor(isToday ? Color.blue.opacity(0.7) : .clear)
                          )
                  }
                  .frame(width: 36, height: 36)
              }

            }
            .padding()
        }
        .navigationTitle("Kalender")
        .onAppear {
            loadCalendarData()
        }
    }

    // Formatterad månad
    private var currentMonthFormatted: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "sv_SE")
        formatter.dateFormat = "LLLL yyyy"
        return formatter.string(from: currentMonth).capitalized
    }

    // Växla månad
    private func changeMonth(by value: Int) {
        if let newMonth = Calendar.current.date(byAdding: .month, value: value, to: currentMonth) {
            currentMonth = newMonth
            loadCalendarData()
        }
    }

    // Ladda kalenderdata
  private func loadCalendarData() {
      goalViewModel.fetchLogs(for: goal.id ?? "") { logs in
          let calendar = Calendar.current

          // Gruppera loggar per dag (alla loggar som hör till samma datum)
          let groupedLogs = Dictionary(grouping: logs) { log in
              calendar.startOfDay(for: log.timestamp)
          }

          // Generera alla datum som ska visas i kalendern
          let allDates = generateDates(for: currentMonth)

          // Mappa till CalendarDay
          self.daysInMonth = allDates.map { date in
              let dayKey = calendar.startOfDay(for: date)

              // summera alla loggvärden för dagen
              let totalCompletedValue = groupedLogs[dayKey]?.reduce(0.0) { sum, log in
                  sum + log.value
              } ?? 0.0

              let goalValue = goal.goalValue ?? 1

              return CalendarDay(
                  date: date,
                  completedValue: totalCompletedValue,
                  goalValue: goalValue
              )
          }
      }
  }

    // Genererar datum för hela månaden + veckostart
    private func generateDates(for month: Date) -> [Date] {
        var dates: [Date] = []
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: month)

        guard let startOfMonth = calendar.date(from: components),
              let range = calendar.range(of: .day, in: .month, for: startOfMonth) else {
            return []
        }

        let firstWeekday = calendar.component(.weekday, from: startOfMonth)
        let leadingSpaces = (firstWeekday + 5) % 7 // måndag som första dag (0-6)

        // 1. Lägg till föregående månadens dagar
        if let previousMonth = calendar.date(byAdding: .month, value: -1, to: startOfMonth),
           let prevRange = calendar.range(of: .day, in: .month, for: previousMonth) {
            let prevMonthDays = prevRange.count
            for i in 0..<leadingSpaces {
                let day = prevMonthDays - leadingSpaces + i + 1
                if let date = calendar.date(bySetting: .day, value: day, of: previousMonth) {
                    dates.append(date)
                }
            }
        }

        // 2. Lägg till nuvarande månadens dagar
        for day in range {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: startOfMonth) {
                dates.append(date)
            }
        }

        // 3. Lägg till kommande månadens dagar tills 42 totalt
        while dates.count < 42 {
            if let lastDate = dates.last,
               let nextDate = calendar.date(byAdding: .day, value: 1, to: lastDate) {
                dates.append(nextDate)
            }
        }
        return dates
    }

}


#Preview {
    // Dummy-mål för visning
    let previewGoal = Goal(
        id: "demo123",
        name: "Meditation",
        description: "Meditera 10 min",
        period: .dayLong,
        currentValue: 0,
        goalValue: 10,
        valueUnit: "min",
        streak: 5,
        lastCompletedDate: Date(),
        emoji: "🧘‍♀️",
        colorHex: "#34C759",
        userId: "user123"
    )

    // Skapa en separat instans av GoalViewModel
    let viewModel = GoalViewModel()

    // Lägg in exempeldata manuellt
    viewModel.goals = [previewGoal]

    return CalendarView(goal: previewGoal)
        .environmentObject(viewModel)
}

