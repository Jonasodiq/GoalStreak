//
//  GoalEditView.swift
//  GoalStreak
//
//  Created by Jonas Niyazson on 2025-05-06.
//

import SwiftUI

struct GoalEditView: View {
    @EnvironmentObject var goalViewModel: GoalViewModel
    @Environment(\.presentationMode) var presentationMode

    var goal: Goal

    @State private var name: String
    @State private var description: String
    @State private var selectedEmoji: String
    @State private var selectedColorHex: String
    @State private var selectedPeriod: GoalPeriod
    @State private var goalValue: String
    @State private var valueUnit: String
    @State private var customColor: Color
    @State private var selectedUnit: String

    let emojis = ["📖", "🏃‍♂️", "🧘‍♀️", "🍎", "💻", "📝", "🎯", "🧠", "💡", "📚"]
  let units = ["count", "steps", "km", "mile", "sec", "min", "hr", "ml", "oz", "Cal", "g", "mg"]

    let predefinedColors: [String: Color] = [
        "#007AFF": .blue,
        "#FF3B30": .red,
        "#34C759": .green,
        "#FF9500": .orange,
        "#AF52DE": .purple,
        "#5AC8FA": .cyan,
        "#FFD60A": .yellow,
        "#8E8E93": .gray,
        "#FF2D55": .pink
    ]

    init(goal: Goal) {
      self.goal = goal
      _name = State(initialValue: goal.name)
      _description = State(initialValue: goal.description ?? "")
      _selectedEmoji = State(initialValue: goal.emoji)
      _selectedColorHex = State(initialValue: goal.colorHex)
      _selectedPeriod = State(initialValue: goal.period ?? .dayLong)
      _goalValue = State(initialValue: goal.goalValue?.clean ?? "")
      _valueUnit = State(initialValue: goal.valueUnit ?? "")
      _customColor = State(initialValue: Color(hex: goal.colorHex) ?? .blue)
      _selectedUnit = State(initialValue: goal.valueUnit ?? "ggr")

    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Namn")) {
                    TextField("Mål", text: $name)
                }

                Section(header: Text("Beskrivning")) {
                    TextField("Beskrivning", text: $description)
                }
              Section(header: Text("Gruppering")) {
                    TextField("Grupp", text: $valueUnit)
                }

                Section(header: Text("Emoji")) {
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(emojis, id: \.self) { emoji in
                              Text(emoji)
                                .font(.largeTitle)
                                .padding(4)
                                .background(selectedEmoji == emoji ? Color.gray.opacity(0.2) : Color.clear)
                                .clipShape(Circle())
                                .onTapGesture {
                                    selectedEmoji = emoji
                                }
                            }
                        }
                    }
                }

              Section(header: Text("Färg")) {
                  VStack(alignment: .leading) {
                      HStack {
                        ForEach(predefinedColors.sorted(by: { $0.key < $1.key }), id: \.key) { hex, color in
                          Circle()
                              .fill(color)
                              .frame(width: 30, height: 30)
                              .overlay(
                                  Circle().stroke(Color.black, lineWidth: selectedColorHex == hex ? 2 : 0)
                              )
                              .onTapGesture {
                                  selectedColorHex = hex
                                  customColor = color
                              }
                          }
                      }

                      ColorPicker("Anpassad färg", selection: $customColor)
                      .onChange(of: customColor) {
                          selectedColorHex = customColor.toHex() ?? "#007AFF"
                      }
                  }
              }

                Section(header: Text("Period")) {
                    Picker("Period", selection: $selectedPeriod) {
                      Text("Daglig").tag(GoalPeriod.dayLong)
                      Text("Veckovis").tag(GoalPeriod.weekLong)
                      Text("Månadsvis").tag(GoalPeriod.monthLong)
                    }
                    .pickerStyle(.segmented)
                }

              Section(header: Text("Målvärde & Enhet")) {
                HStack {
                  TextField("Målvärde", text: $goalValue)
                      .keyboardType(.decimalPad)
                      .textFieldStyle(.roundedBorder)

                  Picker("Enhet", selection: $selectedUnit) {
                      ForEach(units, id: \.self) { unit in
                          Text(unit).tag(unit)
                      }
                  }
                  .pickerStyle(.menu)
                }
              }
            }
            .navigationTitle("Redigera Mål")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                  Button("Spara") {
                    var updatedGoal = goal
                    updatedGoal.name = name
                    updatedGoal.description = description
                    updatedGoal.emoji = selectedEmoji
                    updatedGoal.colorHex = selectedColorHex
                    updatedGoal.period = selectedPeriod
                    updatedGoal.goalValue = Double(goalValue)
                    updatedGoal.valueUnit = valueUnit
                    goalViewModel.updateGoal(updatedGoal)
                    presentationMode.wrappedValue.dismiss()
                  }
                }

                ToolbarItem(placement: .cancellationAction) {
                    Button("Avbryt") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}


#Preview {
    let previewGoal = Goal(
        id: "demo123",
        name: "Read Book",
        description: "Läs minst 20 minuter varje kväll",
        group: "Health",
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

    return GoalEditView(goal: previewGoal)
        .environmentObject(GoalViewModel())
}
