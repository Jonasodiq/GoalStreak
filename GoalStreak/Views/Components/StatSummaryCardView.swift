//
//  StatSummaryCardView.swift
//  GoalStreak
//
//  Created by Jonas Niyazson on 2025-08-15.
//

import SwiftUI

struct StatSummaryCard: View {
    let title: String
    let value: String
    let color: Color
    let icon: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.title2)
            Text(value)
                .font(.title3).bold()
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}


#Preview {
    let dummyGoal = Goal(
        id: "demo123",
        name: "Read Quran",
        description: "Daily Reading",
        period: .dayLong,
        currentValue: 0,
        goalValue: 1,
        valueUnit: "count",
        streak: 5,
        lastCompletedDate: Date(),
        emoji: "📖",
        colorHex: "#34C759",
        userId: "user123"
    )

    return YearlyStatusView(goal: dummyGoal)
        .environmentObject(GoalViewModel())
        .padding()
        .previewLayout(.sizeThatFits)
}
