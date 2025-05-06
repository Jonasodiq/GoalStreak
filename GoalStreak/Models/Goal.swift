//
//  Goal.swift
//  GoalStreak
//
//  Created by Jonas Niyazson on 2025-04-29.
//

import Foundation
import FirebaseFirestore

enum GoalPeriod: String, Codable {
    case dayLong = "Day-Long"
    case weekLong = "Week-Long"
    case monthLong = "Month-Long"
}

struct Goal: Identifiable, Codable {
    @DocumentID var id: String?
    var name: String
    var description: String?
    var group: String?
    var period: GoalPeriod?
    var goalValue: Double?
    var valueUnit: String?
    var streak: Int
    var lastCompletedDate: Date?
    var emoji: String
    var colorHex: String
    var completionDates: [Date]
    var userId: String
}

