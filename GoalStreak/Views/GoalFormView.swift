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

    @EnvironmentObject var goalViewModel: GoalViewModel
    @EnvironmentObject var localizationManager: LocalizationManager
    @Environment(\.presentationMode) var presentationMode

    @State private var name = ""
    @State private var description = ""
    @State private var selectedEmoji = "🎯"
    @State private var selectedColor = Color.blue
    @State private var selectedColorHex = "#2196F3"
    @State private var selectedPeriod: GoalPeriod = .dayLong
    @State private var goalValue = ""
    @State private var selectedUnit = "count"

    let availableEmojis = ["🎯", "📚", "🏃‍♂️", "🧘‍♀️", "💧", "📝", "💪", "🧹", "🍎", "🎨", "📅", "⏰"]
    let units = ["count", "steps", "km", "mile", "sec", "min", "hr", "ml", "oz", "Cal", "g", "mg"]
    let periods: [GoalPeriod] = [.dayLong, .weekLong, .monthLong]

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text(localizationManager.localizedString(for: "name"))) {
                    TextField(localizationManager.localizedString(for: "text_field"), text: $name)
                        .textFieldStyle(.roundedBorder)
                }

                Section(header: Text(localizationManager.localizedString(for: "description"))) {
                    TextField(localizationManager.localizedString(for: "description"), text: $description)
                        .textFieldStyle(.roundedBorder)
                }

                Section(header: Text("Emoji")) {
                  EmojiPickerView(
                          selectedEmoji: $selectedEmoji,
                          availableEmojis: availableEmojis
                      )
                }

                Section(header: Text("Färg")) {
                    ColorPickerView(
                        predefinedColors: Color.predefinedGoalColors,
                        selectedColorHex: .constant(selectedColor.toHex() ?? "#2196F3"),
                        customColor: $selectedColor
                    )
                }

                Section(header: Text("Period")) {
                    Picker("Period", selection: $selectedPeriod) {
                        ForEach(periods, id: \.self) { period in
                            Text(period.rawValue).tag(period)
                        }
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

                Section {
                    Button(buttonTitle) {
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
        case .create: return localizationManager.localizedString(for: "Lägg till")
        case .edit: return localizationManager.localizedString(for: "Redigera")
        }
    }

    private var buttonTitle: String {
        switch mode {
        case .create: return localizationManager.localizedString(for: "save")
        case .edit: return localizationManager.localizedString(for: "Update")
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
