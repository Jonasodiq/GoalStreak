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
}
