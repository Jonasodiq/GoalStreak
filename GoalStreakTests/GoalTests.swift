//
//  GoalTests.swift
//  GoalStreakTests
//
//  Created by Jonas Niyazson on 2025-05-11.
//

import XCTest
@testable import GoalStreak

final class GoalTests: XCTestCase {

    func testGoalIsCompleted_whenCurrentValueEqualsGoalValue() {
        // Arrange
        let goal = Goal(
            id: "1",
            name: "Gå 10k steg",
            description: "Daglig promenad",
            period: .dayLong,
            currentValue: 10000,
            goalValue: 10000,
            valueUnit: "steg",
            streak: 3,
            lastCompletedDate: nil,
            emoji: "🚶‍♂️",
            colorHex: "#00FF00",
            userId: "abc123",
            timeRemaining: nil,
            isRunning: nil
        )

        // Act
        let isCompleted = (goal.currentValue ?? 0) >= (goal.goalValue ?? 0)

        // Assert
        XCTAssertTrue(isCompleted)
    }

    func testGoalIsNotCompleted_whenCurrentValueIsBelowGoalValue() {
        let goal = Goal(
            id: "2",
            name: "Spring",
            description: "Veckomål",
            period: .weekLong,
            currentValue: 3.0,
            goalValue: 5.0,
            valueUnit: "km",
            streak: 1,
            lastCompletedDate: nil,
            emoji: "🏃‍♀️",
            colorHex: "#FF0000",
            userId: "userXYZ",
            timeRemaining: nil,
            isRunning: nil
        )

        let isCompleted = (goal.currentValue ?? 0) >= (goal.goalValue ?? 0)

        XCTAssertFalse(isCompleted)
    }
  
  
    func testGoalCompletion() {
        let goal = Goal(name: "Run 5km", currentValue: 5, goalValue: 5, valueUnit: "km", streak: 0, emoji: "🏃", colorHex: "#FF5733", userId: "user1")
        XCTAssertTrue(goal.isCompleted)
    }

    func testCleanDouble() {
        let number: Double = 3.0
        XCTAssertEqual(number.clean, "3")
    }

    func testIsSameDay() {
        let date1 = Date()
        let date2 = Date()
        XCTAssertTrue(date1.isSameDay(as: date2))
    }
  
}

