//
//  GoalLog.swift
//  GoalStreak
//
//  Created by Jonas Niyazson on 2025-05-02.
//

import Foundation
import FirebaseFirestore

struct GoalLog: Identifiable, Codable {
    @DocumentID var id: String?
    var goalId: String
    var timestamp: Date
    var value: Double // hur mycket användaren gjorde (t.ex. 5 min, 2 km, osv.)
}
