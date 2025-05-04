//
//  WeekData.swift
//  GoalStreak
//
//  Created by Jonas Niyazson on 2025-05-02.
//

import Foundation

struct WeekData: Identifiable {
    let id = UUID()
    let day: String    // Ex: "Mon"
    let date: Date     // Faktiska datumet
    let count: Int     // Hur många gånger vanan markerats den dagen
}
