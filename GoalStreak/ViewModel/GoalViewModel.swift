//
//  GoalViewModel.swift
//  GoalStreak
//
//  Created by Jonas Niyazson on 2025-04-29.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class GoalViewModel: ObservableObject { // ObservableObject → gör att SwiftUI-vyer kan lyssna på ändringar i denna ViewModel och uppdateras automatiskt.
    @Published var goals = [Goal]()
    @Published var goalLogs: [GoalLog] = []
    // @Published → alla vyer som använder goals eller goalLogs kommer uppdateras när dessa listor ändras.

    private var db = Firestore.firestore() // en referens till Firestore-databasen där vi sparar och hämtar data.

    // Fetchs all streaks - Syfte: Hämta alla mål för den nuvarande inloggade användaren och lyssna på förändringar i realtid.
    func fetchGoals() {
      guard let userId = Auth.auth().currentUser?.uid else {
          print("Ingen inloggad användare.")
          return
      }
      print("📡 Hämtar mål för användare: \(userId)")
      
      // whereField("userId", isEqualTo: userId) → filtrerar så vi bara får den inloggade användarens mål.
      db.collection("goals")
        .whereField("userId", isEqualTo: userId)
        .addSnapshotListener { snapshot, error in // → gör att listan uppdateras direkt när något ändras i Firestore.
          if let error = error {
              print("Fel vid hämtning av goals: \(error.localizedDescription)")
              return
          }
          
          guard let documents = snapshot?.documents else {
            print("⚠️ Inga dokument hittades i 'goals'")
            return
          }
          print("✅ Antal mål hämtade: \(documents.count)")
          
          self.goals = documents.compactMap { doc in
              do {
                  let goal = try doc.data(as: Goal.self)
                  print("🎯 Lyckades parsa Goal med id=\(doc.documentID), name=\(goal.name)")
                  return goal
              } catch {
                  print("⚠️ Kunde inte parsa dokument \(doc.documentID): \(error.localizedDescription)")
                  print("Rådata: \(doc.data())")
                  return nil
              }
          }
        }
    }
  
  // Add a new streak
  func addGoal( // Skapar ett nytt Goal-objekt med alla parametrar som skickas in.
      name: String,
      description: String,
      emoji: String,
      colorHex: String,
      period: GoalPeriod,
      goalValue: Double,
      valueUnit: String
  ) {
    guard let userId = Auth.auth().currentUser?.uid else {
      print("❌ Ingen inloggad användare – kan inte lägga till mål.")
      return
    }

      let newGoal = Goal(
          id: nil,
          name: name,
          description: description,
          period: period,
          currentValue: 0,
          goalValue: goalValue,
          valueUnit: valueUnit,
          streak: 0,
          lastCompletedDate: nil,
          emoji: emoji,
          colorHex: colorHex,
          userId: userId,
          
          timeRemaining: Int(goalValue * 60), // standardvärde (om minuter)
          isRunning: false
      )
      // Sparar till Firestore med:
      do { _ = try db.collection("goals").addDocument(from: newGoal)
         } catch {
             print("Fel vid uppladdning av mål: \(error.localizedDescription)")
         }
  }

  // Uppdatera mål
  func updateGoal(_ goal: Goal) {
      guard let id = goal.id else { return }
      do { // Uppdaterar ett mål i Firestore.
          try db.collection("goals").document(id).setData(from: goal, merge: true) // merge: true sparar endast ändringar, inte hela objektet.
          if let index = goals.firstIndex(where: { $0.id == id }) {
              goals[index] = goal // Uppdaterar även listan goals lokalt i appen.
          }
        print("✅ Uppdaterade mål med id: \(id)")
      } catch {
          print("Kunde inte uppdatera mål: \(error.localizedDescription)")
      }
  }
  
  //  Fetchs logs for a specific streak - Hämta loggar för ett mål
  func fetchLogs(for goalId: String, completion: @escaping ([GoalLog]) -> Void) { // Returnerar resultatet via en completion-callback.
      db.collection("logs") // Hämtar alla loggar för ett specifikt mål.
          .whereField("goalId", isEqualTo: goalId)
          .getDocuments { snapshot, error in
              if let error = error {
                  print("Error fetching logs: \(error)")
                  completion([])
                  return
              }
              let logs: [GoalLog] = snapshot?.documents.compactMap { doc in
                  try? doc.data(as: GoalLog.self)
              } ?? []
              completion(logs)
          }
  }
  
  // Remove func
  func deleteGoal(_ goal: Goal) {
      guard let id = goal.id else { return }
      db.collection("goals").document(id).delete { error in
        if let error = error {
            print("❌ Fel vid borttagning: \(error.localizedDescription)")
        } else {
            print("🗑️ Tog bort mål med id: \(id)")
        }
      }
  }
  
  // Clears all - Rensa alla mål lokalt
  func clearGoals() {
      self.goals = []
    print("🧹 Rensade alla mål lokalt (påverkar ej Firestore).")
  } // Används för att tömma listan lokalt, påverkar inte Firestore.
  
  // Fetchs logs for the last 7 days - Hämta loggar för de senaste 7 dagarna
  func fetchWeeklyData(for goalId: String, completion: @escaping ([WeekData]) -> Void) { // Returnerar en lista av WeekData med veckodag, datum och antal.
    let calendar = Calendar.current
    let today = calendar.startOfDay(for: Date()) // Räknar hur många gånger målet har loggats per dag under de senaste 7 dagarna.
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
  
  // Marks a goal as completed and updates the streak
  func markGoalCompleted(goal: Goal) { // Hämtar dagens datum (today) och jämför med senaste gången målet klarades (lastCompletedDate).
      guard let goalID = goal.id else { return }

      let today = Calendar.current.startOfDay(for: Date())
      let lastDate = goal.lastCompletedDate.map { Calendar.current.startOfDay(for: $0) }

      var updatedStreak = goal.streak
//      if lastDate != today {
    if !(lastDate?.isSameDay(as: today) ?? false) {
      // Om målet inte redan är markerat som klart idag:
      // * Om det var klart igår → öka streak med 1.
      // * Annars → börja om streak på 1.

          if let last = lastDate, Calendar.current.isDate(last.addingTimeInterval(86400), inSameDayAs: today) {
              updatedStreak += 1
          } else {
              updatedStreak = 1
          }
          // Uppdaterar Firestore med det nya streak-värdet och datumet.
          db.collection("goals").document(goalID).updateData([
              "streak": updatedStreak,
              "lastCompletedDate": Timestamp(date: today)
          ])
      }
  }
  
  // Updates a time-based goal based on time spent - Uppdatera tidsbaserat mål
  func updateProgress(for goal: Goal, elapsedSeconds: Int) -> Goal {
      var updatedGoal = goal // Räknar om den aktuella tiden till rätt enhet (sec, min, hr) och uppdaterar currentValue.
      let multiplier: Double
      switch goal.valueUnit?.lowercased() {
      case "sec": multiplier = 1
      case "min": multiplier = 60
      case "hr":  multiplier = 3600
      default:    multiplier = 60
      }
      // Sparar till Firestore.
      updatedGoal.currentValue = Double(elapsedSeconds) / multiplier
      updateGoal(updatedGoal)
      return updatedGoal
  }

  // Resets the target's current value to zero - Nollställ mål
  func resetGoal(_ goal: Goal) -> Goal {
      var updatedGoal = goal
      updatedGoal.currentValue = 0 // Sätter nuvarande värde på målet till 0.
      updateGoal(updatedGoal)
      return updatedGoal
  }

  // Sets new goal in minutes - Sätt nytt mål i minuter
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
  
  // Increases the current value of the target by 1 step - Öka värdet med 1
  func incrementValue(for goal: Goal) -> Goal {
      var updatedGoal = goal
      let current = updatedGoal.currentValue ?? 0
      let target = updatedGoal.goalValue ?? 1

      if current < target { // Ökar currentValue med 1 (t.ex. antal repetitioner).
          updatedGoal.currentValue = current + 1
          updateGoal(updatedGoal)
      }

      return updatedGoal
  }

  // Checks if the goal is complete and marks it as done - Kontrollera om målet är klart
  func checkIfGoalCompleted(_ goal: Goal) -> Bool { // Jämför om currentValue ≥ goalValue.
      guard let current = goal.currentValue, let target = goal.goalValue else { return false }
      if current >= target { // Om klart → markerar målet som klart och returnerar true.
          markGoalCompleted(goal: goal)
          return true
      }
      return false
  }
  
  // Lägg till ny logg för ett mål
  func addLog(for goal: Goal, value: Double) {
      guard let goalId = goal.id else {
          print("❌ Kan inte skapa logg – mål saknar id")
          return
      }

      let newLog = GoalLog(
          id: nil,
          goalId: goalId,
          timestamp: Date(),   // nuvarande tid
          value: value
      )

      do {
          try db.collection("goal_logs").addDocument(from: newLog)
          print("✅ Logg sparad för goalId=\(goalId), value=\(value)")

          // 🔄 Uppdatera målets currentValue samtidigt
          var updatedGoal = goal
          updatedGoal.currentValue = (goal.currentValue ?? 0) + value
          updateGoal(updatedGoal)

      } catch {
          print("❌ Kunde inte spara logg: \(error.localizedDescription)")
      }
  }

}
