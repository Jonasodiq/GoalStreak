//
//  TimerView.swift
//  GoalStreak
//
//  Created by Jonas Niyazson on 2025-05-05.
//

import SwiftUI

struct TimerView: View {
    @State private var timeRemaining: Int
    @State private var isRunning = false
    @State private var showTimeInput = false
    @State private var inputMinutes = ""
    @State private var totalTime: Int // total tid i sekunder
    @EnvironmentObject var goalViewModel: GoalViewModel
    var goal: Goal

    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
  
  init(goal: Goal, minutes: Int) {
      self.goal = goal
      let seconds = minutes * 60
      self._timeRemaining = State(initialValue: seconds)
      self._totalTime = State(initialValue: seconds)
  }

    var body: some View {
      let secondAngle = Angle(degrees: Double((60 - timeRemaining % 60)) / 60.0 * 360.0 - 90)

        VStack(spacing: 40) {
          ZStack {
              Circle()
                  .stroke(Color.gray.opacity(0.3), lineWidth: 10)

              Circle()
                  .trim(from: 0, to: progress)
                  .stroke(
                      AngularGradient(gradient: Gradient(colors: [.blue, .green]), center: .center),
                      style: StrokeStyle(lineWidth: 12, lineCap: .round)
                  )
                  .rotationEffect(.degrees(-90))
                  .animation(.easeInOut(duration: 0.3), value: progress)

              // Rullande liten cirkel
            GeometryReader { geometry in
                let size = min(geometry.size.width, geometry.size.height)
                let _: CGFloat = 12
                let radius = size / 2
                let x = radius + cos(secondAngle.radians) * (radius - 0)
                let y = radius + sin(secondAngle.radians) * (radius - 0)

                Circle()
                .fill(Color.gray.opacity(0.5))
                    .frame(width: 16, height: 16)
                    .position(x: x, y: y)
                    .animation(.easeInOut(duration: 0.25), value: timeRemaining)
            }


              Text(timeString(from: timeRemaining))
                  .font(.system(size: 30, weight: .bold, design: .monospaced))
          }
          .frame(width: 200, height: 200)


          VStack {
            HStack(spacing: 30) {
              
              // Plus-knapp
              Button(action: {
                inputMinutes = ""
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
              
              // Play/Pause
              Button(action: {
                isRunning.toggle()
              }) {
                Image(systemName: isRunning ? "pause.fill" : "play.fill")
                  .font(.system(size: 32))
                  .foregroundColor(.white)
                  .padding()
                  .background(isRunning ? Color.orange : Color.green)
                  .clipShape(Circle())
                  .shadow(radius: 5)
              }
              
              // Återställ
              Button(action: {
                timeRemaining = totalTime
                isRunning = false
              }) {
                Image(systemName: "arrow.counterclockwise")
                  .font(.system(size: 18))
                  .foregroundColor(.white)
                  .padding()
                  .background(Color.secondary.opacity(0.3))
                  .clipShape(Circle())
                  .shadow(radius: 5)
              }
            }
            
            Button(action: {
                goalViewModel.markGoalCompleted(goal: goal)
            }) {
              Image(systemName: "checkmark")
                .font(.system(size: 18).bold())
                .padding(14)
                .background(Color.blue)
                .foregroundColor(.white)
                .clipShape(Circle())
            }
            .disabled(isMarkedToday)
            .padding(.top)


          }
        }
        .padding()
        .onReceive(timer) { _ in
            guard isRunning else { return }
            if timeRemaining > 0 {
              timeRemaining -= 1
              SoundPlayer.playSound("tick")
            } else {
              isRunning = false
              SoundPlayer.playSound("done")
            }
        }
        .alert("Ange minuter", isPresented: $showTimeInput) {
            TextField("Minuter", text: $inputMinutes)
                .keyboardType(.numberPad)

            Button("Avbryt", role: .cancel) {}

            Button("Spara") {
                if let newMinutes = Int(inputMinutes), newMinutes > 0 {
                    totalTime = newMinutes * 60
                    timeRemaining = totalTime
                    isRunning = false
                }
            }
        } message: {
            Text("Skriv in hur många minuter du vill räkna ned.")
        }
        .onAppear {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
                if let error = error {
                    print("Notistillstånd fel: \(error.localizedDescription)")
                }
            }
        }

    }

    private var progress: CGFloat {
        guard totalTime > 0 else { return 0 }
        return CGFloat(Double(totalTime - timeRemaining) / Double(totalTime))
    }

    private func timeString(from seconds: Int) -> String {
        let minutes = seconds / 60
        let seconds = seconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
  
  var isMarkedToday: Bool {
      guard let lastDate = goal.lastCompletedDate else { return false }
      return Calendar.current.isDateInToday(lastDate)
  }
}

#Preview {
    let previewGoal = Goal(
        id: "demo123",
        name: "Test Goal",
        description: "Testmål för TimerView",
        group: "Fitness",
        period: .dayLong,
        goalValue: 1.0,
        valueUnit: "ggr",
        streak: 7,
        lastCompletedDate: Date(),
        emoji: "📖",
        colorHex: "#007AFF",
        completionDates: [Date()],
        userId: "user_abc"
    )

    return TimerView(goal: previewGoal, minutes: 1)
        .environmentObject(GoalViewModel()) 
}

