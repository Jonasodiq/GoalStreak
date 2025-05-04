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



//#Preview {
//    // 👇 En mock av GoalViewModel
//    let mockViewModel = GoalViewModel()
//    
//    // 👇 Injecta fake-vecko-data manuellt via fetchWeeklyData
//    class PreviewStatsViewModel: GoalViewModel {
//        override func fetchWeeklyData(for goalId: String, completion: @escaping ([WeekData]) -> Void) {
//            let calendar = Calendar.current
//            let today = calendar.startOfDay(for: Date())
//            let days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
//
//            let fakeData = (0..<7).map { i in
//                WeekData(
//                    day: days[i],
//                    date: calendar.date(byAdding: .day, value: i - 6, to: today)!,
//                    count: Int.random(in: 0...3)
//                )
//            }
//            completion(fakeData)
//        }
//    }
//
//    let dummyGoal = Goal(
//        id: "123",
//        name: "Meditera",
//        streak: 3,
//        lastCompletedDate: Date(),
//        emoji: "🧘‍♀️",
//        colorHex: "#FFAA00",
//        completionDates: [],
//        userId: "testUser"
//    )
//    
//    return StatsView(goal: dummyGoal)
//        .environmentObject(PreviewStatsViewModel())
//        .padding()
//        .previewLayout(.sizeThatFits)
//}




