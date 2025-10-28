//
//  Goal.swift
//  GoalStreak
//
//  Created by Jonas Niyazson on 2025-04-29.
//

import Foundation
import FirebaseFirestore

enum GoalPeriod: String, Codable, CaseIterable {
    case dayLong
    case weekLong
    case monthLong
    
    func localizedName(using LM: LocalizationManager) -> String {
        switch self {
        case .dayLong:
            return LM.LS(for: "daily")
        case .weekLong:
            return LM.LS(for: "weekly")
        case .monthLong:
            return LM.LS(for: "monthly")
        }
    }
}

struct Goal: Identifiable, Codable, Hashable {
    @DocumentID var id: String?
    var name: String
    var description: String?
    var period: GoalPeriod?
    var currentValue: Double? //?
    var goalValue: Double? // ?
    var valueUnit: String? // Count
    var streak: Int
    var lastCompletedDate: Date? // ?
    var emoji: String
    var colorHex: String
    var userId: String
    var timeRemaining: Int? // ?
    var isRunning: Bool? // ?
}

