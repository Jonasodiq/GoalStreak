//
//  Extension.swift
//  GoalStreak
//
//  Created by Jonas Niyazson on 2025-05-02.
//

import Foundation

extension Date {
    func isSameDay(as other: Date) -> Bool {
        Calendar.current.isDate(self, inSameDayAs: other)
    }

    func isSameWeek(as other: Date) -> Bool {
        Calendar.current.component(.weekOfYear, from: self) ==
        Calendar.current.component(.weekOfYear, from: other) &&
        Calendar.current.component(.yearForWeekOfYear, from: self) ==
        Calendar.current.component(.yearForWeekOfYear, from: other)
    }

    func isSameMonth(as other: Date) -> Bool {
        Calendar.current.component(.month, from: self) ==
        Calendar.current.component(.month, from: other) &&
        Calendar.current.component(.year, from: self) ==
        Calendar.current.component(.year, from: other)
    }
}

