//
//  Extension.swift
//  GoalStreak
//
//  Created by Jonas Niyazson on 2025-05-02.
//

import Foundation
import SwiftUICore

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

extension Double {
    var clean: String {
        self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}

extension Goal {
    var isCompleted: Bool {
        guard let current = currentValue, let goal = goalValue else { return false }
        return current >= goal
    }
}

extension View {
    func primaryButtonStyle(backgroundColor: Color) -> some View {
        self
            .fontWeight(.bold)
            .padding()
            .frame(maxWidth: .infinity)
            .background(backgroundColor)
            .foregroundColor(.white)
            .cornerRadius(10)
    }
}
