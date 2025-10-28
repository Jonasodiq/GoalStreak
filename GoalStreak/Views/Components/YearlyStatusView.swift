//
//  YearlyStatusView.swift
//  GoalStreak
//
//  Created by Jonas Niyazson on 2025-08-15.
//

import SwiftUI

struct YearlyStatusView: View {
    let goal: Goal
    @EnvironmentObject var goalViewModel: GoalViewModel

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 2) {
                ForEach(0..<365, id: \.self) { dayOffset in
                    let colorIntensity = Double.random(in: 0...1) // Placeholder – här hämtar vi logdata
                    Rectangle()
                        .fill(Color.green.opacity(colorIntensity))
                        .frame(width: 8, height: 8)
                        .cornerRadius(2)
                }
            }
            .padding(.horizontal)
        }
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
