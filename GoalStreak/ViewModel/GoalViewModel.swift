//
//  GoalViewModel.swift
//  GoalStreak
//
//  Created by Jonas Niyazson on 2025-04-29.
//

import Foundation
import FirebaseFirestore

class GoalViewModel: ObservableObject { // automatiskt uppdaterar vyn när goals ändras
  @Published var goals = [Goal]()
  private var db = Firestore.firestore()

  init() {
      fetchGoals()
  }

  func fetchGoals() {
      db.collection("goals").addSnapshotListener { snapshot, error in
          guard let documents = snapshot?.documents else { return }
          self.goals = documents.compactMap { try? $0.data(as: Goal.self) }
      }
  }

  // Skapar ett nytt mål med streak 0.
  func addGoal(name: String) {
      let newGoal = Goal(name: name, streak: 0, lastCompletedDate: nil)
      do {
          _ = try db.collection("goals").addDocument(from: newGoal)
      } catch {
          print("Fel vid sparande: \(error)")
      }
  }

  // Uppdaterar streak
  func completeGoal(_ goal: Goal) {
    guard let id = goal.id else { return }

    let today = Calendar.current.startOfDay(for: Date())
    var updated = goal

    if let last = goal.lastCompletedDate,
       Calendar.current.isDate(last, inSameDayAs: today) {
        // redan markerad idag, gör inget
        return
    }

    if let last = goal.lastCompletedDate,
       Calendar.current.isDate(last, inSameDayAs: Calendar.current.date(byAdding: .day, value: -1, to: today)!) {
        updated.streak += 1 // Om det var igår → öka streak
    } else {
        updated.streak = 1 // Om det var tidigare → sätt streak till 1
    }

    updated.lastCompletedDate = today

    do {
        try db.collection("goals").document(id).setData(from: updated)
    } catch {
        print("Fel vid uppdatering: \(error)")
    }
  }
  
  // Datumformattering
  func formattedDate(_ date: Date?) -> String {
      guard let date = date else { return "-" }
      let formatter = DateFormatter()
      formatter.dateStyle = .medium
      return formatter.string(from: date)
  }
  
  // Koll på markerat idag
  func isCompletedToday(_ goal: Goal) -> Bool {
      guard let date = goal.lastCompletedDate else { return false }
      return Calendar.current.isDateInToday(date)
  }
}
