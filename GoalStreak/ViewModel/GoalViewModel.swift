//
//  GoalViewModel.swift
//  GoalStreak
//
//  Created by Jonas Niyazson on 2025-04-29.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class GoalViewModel: ObservableObject {
    @Published var goals = [Goal]()
    @Published var goalLogs: [GoalLog] = []

    private var db = Firestore.firestore()

    // Fetchs all streaks
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
  
  // Add a new streak
  func addGoal(
      name: String,
      description: String,
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
          period: period,
          goalValue: goalValue,
          valueUnit: valueUnit,
          streak: 0,
          lastCompletedDate: nil,
          emoji: emoji,
          colorHex: colorHex,
          userId: userId
      )

      do { _ = try db.collection("goals").addDocument(from: newGoal)
         } catch {
             print("Fel vid uppladdning av mål: \(error.localizedDescription)")
         }
  }

  // Marks a goal as completed and updates the streak
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
  
  // Updates in the database
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
  
  // Remove func
  func deleteGoal(_ goal: Goal) {
      guard let id = goal.id else { return }
      db.collection("goals").document(id).delete { error in
          if let error = error {
              print("Fel vid borttagning: \(error)")
          }
      }
  }
  
  //  Fetchs logs for a specific streak
  func fetchLogs(for goalId: String, completion: @escaping ([GoalLog]) -> Void) {
    db.collection("goal_logs")
    .whereField("goalId", isEqualTo: goalId)
    .getDocuments { snapshot, _ in
        let logs = snapshot?.documents.compactMap { try? $0.data(as: GoalLog.self) } ?? []
        completion(logs)
    }
  }
  
  // Clears all
  func clearGoals() {
      self.goals = []
  }
  
  // Fetchs logs for the last 7 days
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
  
  // Updates a time-based goal based on time spent
  func updateProgress(for goal: Goal, elapsedSeconds: Int) -> Goal {
      var updatedGoal = goal
      let multiplier: Double
      switch goal.valueUnit?.lowercased() {
      case "sec": multiplier = 1
      case "min": multiplier = 60
      case "hr":  multiplier = 3600
      default:    multiplier = 60
      }

      updatedGoal.currentValue = Double(elapsedSeconds) / multiplier
      updateGoal(updatedGoal)
      return updatedGoal
  }

  // Resets the target's current value to zero
  func resetGoal(_ goal: Goal) -> Goal {
      var updatedGoal = goal
      updatedGoal.currentValue = 0
      updateGoal(updatedGoal)
      return updatedGoal
  }

  // Sets new goal in minutes
  func setGoalValue(for goal: Goal, minutes: Int) -> Goal {
      var updatedGoal = goal
      switch goal.valueUnit?.lowercased() {
      case "min":
          updatedGoal.goalValue = Double(minutes)
      case "sec":
          updatedGoal.goalValue = Double(minutes * 60)
      case "hr":
          updatedGoal.goalValue = Double(minutes) / 60.0
      default:
          break
      }
      updateGoal(updatedGoal)
      return updatedGoal
  }
  
  // Increases the current value of the target by 1 step and returns the updated target
  func incrementValue(for goal: Goal) -> Goal {
      var updatedGoal = goal
      let current = updatedGoal.currentValue ?? 0
      let target = updatedGoal.goalValue ?? 1

      if current < target {
          updatedGoal.currentValue = current + 1
          updateGoal(updatedGoal)
      }

      return updatedGoal
  }

  // Checks if the goal is complete and marks it as done
  func checkIfGoalCompleted(_ goal: Goal) -> Bool {
      guard let current = goal.currentValue, let target = goal.goalValue else { return false }
      if current >= target {
          markGoalCompleted(goal: goal)
          return true
      }
      return false
  }
}
