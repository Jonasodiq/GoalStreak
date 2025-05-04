//
//  GoalViewModel.swift
//  GoalStreak
//
//  Created by Jonas Niyazson on 2025-04-29.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class GoalViewModel: ObservableObject {
    @Published var goals = [Goal]()
    @Published var goalLogs: [GoalLog] = []
    private var db = Firestore.firestore()

    init() {
//        fetchGoals()
    }

  func fetchGoals() {
      guard let userId = Auth.auth().currentUser?.uid else {
          print("Ingen inloggad användare.")
          return
      }
    print("✅ Hämtar mål för användare med ID: \(userId)")

      db.collection("goals")
          .whereField("userId", isEqualTo: userId)
          .addSnapshotListener { snapshot, error in
            if let error = error {
                print("❌ Fel vid hämtning av goals: \(error.localizedDescription)")
                return
            }
            
            guard let documents = snapshot?.documents else {
                print("⚠️ Inga dokument hittades.")
                return
            }

            print("📄 Hittade \(documents.count) dokument.")
            
            self.goals = documents.compactMap {
                do {
                    return try $0.data(as: Goal.self)
                } catch {
                    print("❌ Kunde inte deserialisera dokument: \(error)")
                    return nil
                }
            }

          }
  }

  func addGoal(name: String, emoji: String, colorHex: String) {
      guard let userId = Auth.auth().currentUser?.uid else { return }
      
      let newGoal = Goal(
          name: name,
          streak: 0,
          lastCompletedDate: nil,
          emoji: emoji,
          colorHex: colorHex,
          userId: userId
      )
      
    do {
        _ = try db.collection("goals").addDocument(from: newGoal)
        print("✅ Mål tillagt")
    } catch {
        print("❌ Fel vid uppladdning av mål: \(error.localizedDescription)")
    }

  }

  func markGoalCompleted(goal: Goal) {
      guard let goalID = goal.id else { return }

      let today = Calendar.current.startOfDay(for: Date())
      let lastDate = goal.lastCompletedDate.map { Calendar.current.startOfDay(for: $0) }

      var updatedStreak = goal.streak
      if lastDate != today {
          if let last = lastDate, Calendar.current.isDate(last.addingTimeInterval(86400), inSameDayAs: today) {
              updatedStreak += 1
          } else {
              updatedStreak = 1
          }

          db.collection("goals").document(goalID).updateData([
              "streak": updatedStreak,
              "lastCompletedDate": Timestamp(date: today)
          ])
      }
  }
  
  func deleteGoal(_ goal: Goal) {
      guard let id = goal.id else { return }
      db.collection("goals").document(id).delete { error in
          if let error = error {
              print("Fel vid borttagning: \(error)")
          }
      }
  }
  
  func fetchLogs(for goalId: String, completion: @escaping ([GoalLog]) -> Void) {
    db.collection("goal_logs")
    .whereField("goalId", isEqualTo: goalId)
    .getDocuments { snapshot, _ in
        let logs = snapshot?.documents.compactMap { try? $0.data(as: GoalLog.self) } ?? []
        completion(logs)
    }
  }
  
  func clearGoals() {
      self.goals = []
  }
  
  func fetchWeeklyData(for goalId: String, completion: @escaping ([WeekData]) -> Void) {
      let calendar = Calendar.current
      let today = calendar.startOfDay(for: Date())
      guard let weekAgo = calendar.date(byAdding: .day, value: -6, to: today) else {
          completion([])
          return
      }

      db.collection("goal_logs")
          .whereField("goalId", isEqualTo: goalId)
          .whereField("timestamp", isGreaterThanOrEqualTo: weekAgo)
          .getDocuments { snapshot, error in
              guard let documents = snapshot?.documents else {
                  print("⚠️ Inga loggar hittades: \(error?.localizedDescription ?? "okänt fel")")
                  completion([])
                  return
              }

              let logs = documents.compactMap { try? $0.data(as: GoalLog.self) }

              var counts: [Date: Int] = [:]
              for log in logs {
                  let day = calendar.startOfDay(for: log.timestamp)
                  counts[day, default: 0] += 1
              }

              let days = (0...6).map { offset -> WeekData in
                  let date = calendar.date(byAdding: .day, value: -6 + offset, to: today)!
                  let weekday = calendar.shortWeekdaySymbols[calendar.component(.weekday, from: date) - 1]
                  return WeekData(day: weekday, date: date, count: counts[calendar.startOfDay(for: date)] ?? 0)
              }

              completion(days)
          }
  }


}
