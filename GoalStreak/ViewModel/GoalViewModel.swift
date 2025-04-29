//
//  GoalViewModel.swift
//  GoalStreak
//
//  Created by Jonas Niyazson on 2025-04-29.
//

import Foundation
import FirebaseFirestore

class GoalViewModel: ObservableObject {
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

    func addGoal(name: String) {
        let newGoal = Goal(name: name, streak: 0, lastCompletedDate: nil)
        do {
            _ = try db.collection("goals").addDocument(from: newGoal)
        } catch {
            print("Fel vid sparande: \(error)")
        }
    }

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
            updated.streak += 1
        } else {
            updated.streak = 1
        }

        updated.lastCompletedDate = today

        do {
            try db.collection("goals").document(id).setData(from: updated)
        } catch {
            print("Fel vid uppdatering: \(error)")
        }
    }
}
