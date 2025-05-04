//
//  Goal.swift
//  GoalStreak
//
//  Created by Jonas Niyazson on 2025-04-29.
//

import Foundation
import FirebaseFirestore

struct Goal: Identifiable, Codable {
    @DocumentID var id: String?
    var name: String
    var streak: Int
    var lastCompletedDate: Date?
    var emoji: String
    var colorHex: String
    var completionDates: [Date] = []
    var userId: String
}
