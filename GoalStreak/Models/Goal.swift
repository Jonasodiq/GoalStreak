//
//  Goal.swift
//  GoalStreak
//
//  Created by Jonas Niyazson on 2025-04-29.
//

import Foundation
import FirebaseFirestore

enum GoalPeriod: String, Codable {
    case dayLong = "Daglig"
    case weekLong = "Veckovis"
    case monthLong = "Månadsvis"
}

struct Goal: Identifiable, Codable {
    @DocumentID var id: String?
    var name: String
    var description: String?
    var period: GoalPeriod?
    var currentValue: Double?
    var goalValue: Double?
    var valueUnit: String?
    var streak: Int
    var lastCompletedDate: Date?
    var emoji: String
    var colorHex: String
    var userId: String
}
