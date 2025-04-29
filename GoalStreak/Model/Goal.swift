//
//  Goal.swift
//  GoalStreak
//
//  Created by Jonas Niyazson on 2025-04-29.
//

import Foundation
import FirebaseFirestore

struct Goal: Identifiable, Codable {
    @DocumentID var id: String? // Spara,läsa och ändra från Firestore direkt som objekt
    var name: String
    var streak: Int // Hur många dagar i rad
    var lastCompletedDate: Date? // Senaste dagen målet markerades
}
