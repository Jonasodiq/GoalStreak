//
//  WeekData.swift
//  GoalStreak
//
//  Created by Jonas Niyazson on 2025-05-02.
//

import Foundation

struct WeekData: Identifiable {
    let id = UUID()
    let day: String 
    let date: Date
    let count: Int
}
