//
//  GoalFormView.swift
//  GoalStreak
//
//  Created by Jonas Niyazson on 2025-05-08.
//

import SwiftUI

struct GoalFormView: View {
    enum Mode {
        case create
        case edit(Goal)
    }

    let mode: Mode
    @Binding var selectedTab: Int
    
    // MARK: - Environment
    @EnvironmentObject var goalViewModel: GoalViewModel
    @EnvironmentObject var LM: LocalizationManager
    @Environment(\.presentationMode) var presentationMode

    // MARK: - STATE
    @State private var name = ""
    @State private var description = ""
    @State private var selectedEmoji = "🎯"
    @State private var selectedColor = Color.blue
    @State private var selectedColorHex = "#2196F3"
    @State private var selectedPeriod: GoalPeriod = .dayLong
    @State private var goalValue = ""
    @State private var selectedUnit = "count"

    let availableEmojis = ["🎯","📚","🚶🏼‍♂️","🧘‍♀️","💧","📝","💪","🧹","🍎", "🎨","📅","🍭","⏰","🛒","🚰","👨‍💻","🕌" ]
    let units = ["count", "steps", "km", "mile", "min", "hr", "l", "ml", "g", "mg", "oz", "Cal"]
    let periods: [GoalPeriod] = [.dayLong, .weekLong, .monthLong]

  // MARK: - BODY
  var body: some View {
    NavigationView {
      Form {
        // MARK: - Name
        Section(header: Text(LM.localizedString(for: "name"))) {
          TextField(LM.localizedString(for: "text_field"), text: $name)
            .textFieldStyle(.roundedBorder)
        }
        // MARK: - Description
        Section(header: Text(LM.localizedString(for: "description"))) {
          TextField(LM.localizedString(for: "description"), text: $description)
            .textFieldStyle(.roundedBorder)
        }
        // MARK: - Emoji
        Section(header: Text("Emoji")) {
          EmojiPickerView(
            selectedEmoji: $selectedEmoji,
            availableEmojis: availableEmojis
          )
        }
        // MARK: - Color
        Section(header: Text("Färg")) {
          ColorPickerView(
            predefinedColors: Color.predefinedGoalColors,
            selectedColorHex: .constant(selectedColor.toHex() ?? "#2196F3"),
            customColor: $selectedColor
          )
        }
        // MARK: - Period
        Section(header: Text("Period")) {
          Picker("Period", selection: $selectedPeriod) {
            ForEach(periods, id: \.self) { period in
              Text(period.rawValue).tag(period)
            }
          }
          .pickerStyle(.segmented)
          .onChange(of: selectedPeriod) { oldValue, newValue in
            SoundPlayer.play("pop")
          }
        }
        // MARK: - Value & Unit
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
            .onChange(of: selectedUnit) {
              SoundPlayer.play("pop")
            }
          }
        }
        // MARK: - Save BTN
        Section {
          Button(buttonTitle) {
            SoundPlayer.play("click")
            save()
          }
          .disabled(!isValid)
          .buttonStyle(.borderedProminent)
        }
      }
      .navigationTitle(modeTitle)
      .onAppear(perform: populateFieldsIfNeeded)
    }
  }


  private var isValid: Bool {
    !name.isEmpty && Double(goalValue) != nil
  }

  private var modeTitle: String {
    switch mode {
      case .create: return LM.localizedString(for: "Lägg till")
      case .edit: return LM.localizedString(for: "Redigera")
    }
  }

  private var buttonTitle: String {
    switch mode {
      case .create: return LM.localizedString(for: "Save")
      case .edit: return LM.localizedString(for: "Spara")
    }
  }

  private func populateFieldsIfNeeded() {
    if case let .edit(goal) = mode {
      name = goal.name
      description = goal.description ?? ""
      selectedEmoji = goal.emoji
      selectedColorHex = goal.colorHex
      selectedColor = Color(hex: goal.colorHex) ?? .blue
      selectedPeriod = goal.period ?? .dayLong
      goalValue = goal.goalValue?.clean ?? ""
      selectedUnit = goal.valueUnit ?? "count"
    }
  }

  private func save() {
    guard let value = Double(goalValue) else { return }
    let hex = selectedColor.toHex() ?? "#2196F3"

    switch mode {
    case .create:
      goalViewModel.addGoal(
        name: name,
        description: description,
        emoji: selectedEmoji,
        colorHex: hex,
        period: selectedPeriod,
        goalValue: value,
        valueUnit: selectedUnit
      )
      selectedTab = 0

    case .edit(var goal):
      goal.name = name
      goal.description = description
      goal.emoji = selectedEmoji
      goal.colorHex = hex
      goal.period = selectedPeriod
      goal.goalValue = value
      goal.valueUnit = selectedUnit
      goalViewModel.updateGoal(goal)
      presentationMode.wrappedValue.dismiss()
    }
  }
}

// MARK: - PREVIEW
#Preview {
    GoalFormView(mode: .create, selectedTab: .constant(1))
        .environmentObject(GoalViewModel())
        .environmentObject(LocalizationManager())
}
