//
//  TimerView.swift
//  GoalStreak
//
//  Created by Jonas Niyazson on 2025-05-05.
//

import SwiftUI

struct TimerView: View {
  
    // MARK: - STATE
    @State private var timeRemaining: Int
    @State private var isRunning = false
    @State private var showTimeInput = false
    @State private var inputMinutes = ""
    @State private var totalTime: Int
    @State private var showCompletionCelebration = false
    @State private var localGoalValue: Double = 1
    @State private var localCurrentValue: Double = 0

    @EnvironmentObject var goalViewModel: GoalViewModel
    var goal: Goal

    // Timer
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    // Initializes TimerView based on target value and time unit
    init(goal: Goal) { self.goal = goal

        var second = 60
        if let value = goal.goalValue,
         let unit = goal.valueUnit?.lowercased() {
          switch unit {
            case "sec": second = Int(value)
            case "min": second = Int(value * 60)
            case "hr" : second = Int(value * 3600)
            default : break
          }
        }
        self._timeRemaining = State(initialValue: second)
        self._totalTime = State(initialValue: second)
        self._localGoalValue = State(initialValue: goal.goalValue ?? 1)
        self._localCurrentValue = State(initialValue: goal.currentValue ?? 0)
    }
    
    // MARK: - BODY
    var body: some View {
        let secondAngle = Angle(degrees: Double((60 - timeRemaining % 60)) / 60.0 * 360.0 - 90)

        VStack(spacing: 40) {
          ZStack {
            Circle() // Gray
              .stroke(Color.gray.opacity(0.3), lineWidth: 10)
            Circle() // Green
              .trim(from: 0, to: progress)
              .stroke(
                AngularGradient(gradient: Gradient(colors: [.blue, .green]), center: .center),
                style: StrokeStyle(lineWidth: 12, lineCap: .round)
              )
              .rotationEffect(.degrees(-90))
              .animation(.easeInOut(duration: 0.3), value: progress)

            GeometryReader { geometry in
              let size = min(geometry.size.width, geometry.size.height)
              let radius = size / 2
              let x = radius + cos(secondAngle.radians) * radius
              let y = radius + sin(secondAngle.radians) * radius

              Circle() // Orange
                .fill(Color.orange)
                .frame(width: 16, height: 16)
                .position(x: x, y: y)
                .animation(.easeInOut(duration: 0.25), value: timeRemaining)
            }

            Text(
              isTimeBasedGoal
              ? timeString(from: timeRemaining)
              : "\(Int(localCurrentValue)) / \(Int(goal.goalValue ?? 1)) \(goal.valueUnit ?? "")"
            )
            .font(.system(size: 30, weight: .bold, design: .monospaced))
          } //: - ZStack
          .frame(width: 200, height: 200)

          VStack {
            HStack(spacing: 30) {
              
              // MARK: - Plus BTN
              Button(action: {
                if isTimeBasedGoal {
                        let currentMinutes = totalTime / 60
                        inputMinutes = "\(currentMinutes)"
                    } else {
                        inputMinutes = "\(Int(localGoalValue))"
                    }
                    SoundPlayer.play("pop")
                    showTimeInput = true
              }) {
                Image(systemName: "plus")
                  .font(.system(size: 18))
                  .foregroundColor(.white)
                  .padding()
                  .background(Color.secondary.opacity(0.3))
                  .clipShape(Circle())
                  .shadow(radius: 5)
              }

              // MARK: - Play BTN
              Button(action: {
                if isTimeBasedGoal {
                  if isRunning {
                    isRunning = false
                    saveTimerState()
                    var updatedGoal = goal
                    let secondsSpent = totalTime - timeRemaining
                    updatedGoal.currentValue = Double(secondsSpent) / timeUnitMultiplier
                    goalViewModel.updateGoal(updatedGoal)
                    localCurrentValue = updatedGoal.currentValue ?? 0
                  } else {
                      isRunning = true
                  }
                } else {
                  var updatedGoal = goal
                  let current = updatedGoal.currentValue ?? 0
                  let target = updatedGoal.goalValue ?? 1

                  if current < target {
                    updatedGoal.currentValue = current + 1
                    goalViewModel.updateGoal(updatedGoal)
                    localCurrentValue = updatedGoal.currentValue ?? 0
                    localGoalValue = updatedGoal.goalValue ?? 1
                    SoundPlayer.play("click")
                  }

                  if updatedGoal.currentValue ?? 0 >= target {
                    goalViewModel.markGoalCompleted(goal: updatedGoal)
                    showCelebration()
                    SoundPlayer.play("done")
                  }
                }
              }) {
                Image(systemName: isRunning ? "pause.fill" : "play.fill")
                  .font(.system(size: 32))
                  .foregroundColor(.white)
                  .padding()
                  .background(isRunning ? Color.orange : Color.green)
                  .clipShape(Circle())
                  .shadow(radius: 5)
              }

              // MARK: - Reset BTN
              Button(action: {
                SoundPlayer.play("reset")
                  isRunning = false
                  if isTimeBasedGoal {
                      timeRemaining = totalTime
                  } else {
                      var updatedGoal = goal
                      updatedGoal.currentValue = 0
                      goalViewModel.updateGoal(updatedGoal)
                      localCurrentValue = 0
                  }
              }) {
                Image(systemName: "arrow.counterclockwise")
                  .font(.system(size: 18))
                  .foregroundColor(.white)
                  .padding()
                  .background(Color.secondary.opacity(0.3))
                  .clipShape(Circle())
                  .shadow(radius: 5)
              }
            } //: - HStack End
          } //: - VStack
        } //: - Big-VStack
        .padding()
        // MARK: - Timer update
        .onReceive(timer) { _ in
          guard isRunning else { return }

          if timeRemaining > 0 {
              timeRemaining -= 1
              SoundPlayer.play("tick")
          } else {
              isRunning = false
              SoundPlayer.play("done")

              if isTimeBasedGoal {
                  var updatedGoal = goal
                  updatedGoal.currentValue = localGoalValue
                  goalViewModel.markGoalCompleted(goal: updatedGoal)
                  showCelebration()
              }
          }

          // Update currentValue for time-based
          if isTimeBasedGoal {
            let secondsSpent = totalTime - timeRemaining
            var updatedGoal = goal
            updatedGoal.currentValue = Double(secondsSpent) / timeUnitMultiplier
            goalViewModel.updateGoal(updatedGoal)
            localCurrentValue = updatedGoal.currentValue ?? 0
          }
        }
        
        // MARK: - Plus Time alert BTN
        .alert(isTimeBasedGoal ? "Ange minuter" : "Ange nytt Streak", isPresented: $showTimeInput) {
          TextField("Minuter", text: $inputMinutes)
              .keyboardType(.numberPad)

          Button("Avbryt", role: .cancel) {
            SoundPlayer.play("pop")
          }

          Button("Spara") {
              guard let newValue = Double(inputMinutes), newValue > 0 else { return }

              var updatedGoal = goal

              if isTimeBasedGoal {
                  totalTime = Int(newValue * 60)
                  timeRemaining = totalTime
                  isRunning = false

                  switch goal.valueUnit?.lowercased() {
                    case "min": updatedGoal.goalValue = newValue
                    case "sec": updatedGoal.goalValue = newValue * 60
                    case "hr" : updatedGoal.goalValue = newValue / 60
                    default: break
                  }
              } else {
                  updatedGoal.goalValue = newValue
              }
              SoundPlayer.play("pop")
              goalViewModel.updateGoal(updatedGoal)
              localGoalValue = updatedGoal.goalValue ?? 1
          }
        } message: {
          Text(isTimeBasedGoal ? "Mata in minuter." : "Ange nytt värde för Streak.")
        }
        .onAppear { // Request notice right
          loadTimerState()
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
                if let error = error {
                    print("Notistillstånd fel: \(error.localizedDescription)")
                }
            }
        }
        .overlay( // Goal ready banner
          VStack {
            if showCompletionCelebration {
              
              Text("🎉 Streak klart!")
                .font(.headline.bold())
                .foregroundColor(.white)
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(Color.orange)
                .cornerRadius(16)
                .shadow(radius: 5)
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .padding(.top, 60)
                .animation(.spring(), value: showCompletionCelebration)
            }
            Spacer()
          }
        )
        .onDisappear {
          if isTimeBasedGoal {
            // Save to UserDefaults
            saveTimerState()
            // Save to Firebase
            let secondsSpent = totalTime - timeRemaining
            var updatedGoal = goal
            updatedGoal.currentValue = Double(secondsSpent) / timeUnitMultiplier
            goalViewModel.updateGoal(updatedGoal)
            localCurrentValue = updatedGoal.currentValue ?? 0
          }
        }
    } //: - Body

  
  private var isTimeBasedGoal: Bool {
      guard let unit = goal.valueUnit?.lowercased() else { return false }
      return ["sec", "min", "hr"].contains(unit)
  }
  
  // Convert seconds to the correct unit
  private var timeUnitMultiplier: Double {
      switch goal.valueUnit?.lowercased() {
      case "sec": return 1      // 1 sek
      case "min": return 60     // 1 min = 60 sek
      case "hr" : return 3600   // 1 time = 3600 sek
      default   : return 60     // Standard = min
      }
  }
  
  // Calculates progress as a percentage
  private var progress: CGFloat {
      if isTimeBasedGoal {
        guard totalTime > 0 else { return 0 } // Avoid division by zero
        return CGFloat(Double(totalTime - timeRemaining) / Double(totalTime))
      } else { // Progress based on number (3/10 steps)
          return CGFloat(min(localCurrentValue / localGoalValue, 1.0))
      }
  }

  // Formats seconds to string
  private func timeString(from seconds: Int) -> String {
      let minutes = seconds / 60
      let seconds = seconds % 60
      return String(format: "%02d:%02d", minutes, seconds)
  }

  // Display alert for 2 sec with animation
  private func showCelebration() {
      withAnimation {
          showCompletionCelebration = true
      }
      DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
          withAnimation {
              showCompletionCelebration = false
          }
      }
  }

  // Checks if the goal is marked as done today
  var isMarkedToday: Bool {
      guard let lastDate = goal.lastCompletedDate else { return false }
      return Calendar.current.isDateInToday(lastDate)
  }
  
  private var timerKey: String {
      "timer_\(goal.id ?? "unknown")"
  }

  private func saveTimerState() {
      let data: [String: Any] = [
          "timeRemaining": timeRemaining,
          "timestamp": Date().timeIntervalSince1970
      ]
      UserDefaults.standard.set(data, forKey: timerKey)
  }

  private func loadTimerState() {
      guard let saved = UserDefaults.standard.dictionary(forKey: timerKey),
            let savedTime = saved["timeRemaining"] as? Int,
            let savedTimestamp = saved["timestamp"] as? TimeInterval else { return }

      let elapsed = Int(Date().timeIntervalSince1970 - savedTimestamp)
      let adjustedTime = max(savedTime - elapsed, 0)

      self.timeRemaining = adjustedTime
  }

}

// MARK: - PREVIEW
#Preview {
    let previewGoal = Goal(
        id: "preview123",
        name: "Meditera",
        description: "Meditera 10 minuter",
        period: .dayLong,
        currentValue: 3,
        goalValue: 10,
        valueUnit: "min",
        streak: 3,
        lastCompletedDate: Date(),
        emoji: "🧘‍♀️",
        colorHex: "#34C759",
        userId: "user123"
    )

    TimerView(goal: previewGoal)
        .environmentObject(GoalViewModel())
}
