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

    // Hämtar alla mål som tillhör inloggad användare
    func fetchGoals() {
      guard let userId = Auth.auth().currentUser?.uid else {
          print("Ingen inloggad användare.")
          return
      }

      db.collection("goals")
        .whereField("userId", isEqualTo: userId)
        .addSnapshotListener { snapshot, error in
          if let error = error {
              print("Fel vid hämtning av goals: \(error.localizedDescription)")
              return
          }
          
          guard let documents = snapshot?.documents else {return}
          
          self.goals = documents.compactMap {
              try? $0.data(as: Goal.self)
          }
        }
    }
  
  // Lägger till ett nytt mål
  func addGoal(
      name: String,
      description: String,
      group: String,
      emoji: String,
      colorHex: String,
      period: GoalPeriod,
      goalValue: Double,
      valueUnit: String
  ) {
      guard let userId = Auth.auth().currentUser?.uid else { return }

      let newGoal = Goal(
          id: nil,
          name: name,
          description: description,
          group: group,
          period: period,
          goalValue: goalValue,
          valueUnit: valueUnit,
          streak: 0,
          lastCompletedDate: nil,
          emoji: emoji,
          colorHex: colorHex,
          completionDates: [],
          userId: userId
      )

      do { _ = try db.collection("goals").addDocument(from: newGoal)
         } catch {
             print("Fel vid uppladdning av mål: \(error.localizedDescription)")
         }
  }

  // Markerar ett mål som slutfört
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
  
  func updateGoal(_ goal: Goal) {
      guard let id = goal.id else { return }
      do {
          try db.collection("goals").document(id).setData(from: goal)
          if let index = goals.firstIndex(where: { $0.id == id }) {
              goals[index] = goal
          }
      } catch {
          print("Kunde inte uppdatera mål: \(error.localizedDescription)")
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
  
  // Hämtar loggar för ett specifikt mål
  func fetchLogs(for goalId: String, completion: @escaping ([GoalLog]) -> Void) {
    db.collection("goal_logs")
    .whereField("goalId", isEqualTo: goalId)
    .getDocuments { snapshot, _ in
        let logs = snapshot?.documents.compactMap { try? $0.data(as: GoalLog.self) } ?? []
        completion(logs)
    }
  }
  
  // Rensar alla lokala mål
  func clearGoals() {
      self.goals = []
  }
  
  // Hämtar loggar de senaste 7 dagarna och räknar förekomster per dag
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
              print("Inga loggar hittades: \(error?.localizedDescription ?? "okänt fel")")
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
