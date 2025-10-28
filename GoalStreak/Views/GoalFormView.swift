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
        Section(header: Text(LM.LS(for: "name_section"))) {
          TextField(LM.LS(for: "text_field"), text: $name)
            .textFieldStyle(.roundedBorder)
        }
        // MARK: - Description
        Section(header: Text(LM.LS(for: "desc_section"))) {
          TextField(LM.LS(for: "desc"), text: $description)
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
        Section(header: Text(LM.LS(for: "color_section"))) {
          ColorPickerView(
            predefinedColors: Color.predefinedGoalColors,
            selectedColorHex: .constant(selectedColor.toHex() ?? "#2196F3"),
            customColor: $selectedColor
            
            /**
             ✅ Positivt:
             Flexibel enum Mode för edit/create.
             Bra validering i isValid.
             ⚠️ Buggrisk: selectedColorHex sätts men används inte
             .selectedColorHex: .constant(selectedColor.toHex() ?? "#2196F3"),
             Detta är en constant, men ska kanske vara bindning? Annars kan användaren inte se uppdaterat hex-värde om hen väljer en färg.
             */
          )
        }
        // MARK: - Period
        Section(header: Text(LM.LS(for: "Period"))) {
            Picker(LM.LS(for: "Period"), selection: $selectedPeriod) {
                ForEach(periods, id: \.self) { period in
                    Text(period.localizedName(using: LM))
                        .tag(period)
                }
            }
            .pickerStyle(.segmented)
            .onChange(of: selectedPeriod) { oldValue, newValue in
                SoundPlayer.play("pop")
            }
        }

        // MARK: - Value & Unit
        Section(header: Text(LM.LS(for: "unit_section"))) {
          HStack {
            TextField(LM.LS(for: "unit_field"), text: $goalValue)
              .keyboardType(.decimalPad)
              .textFieldStyle(.roundedBorder)
            Picker(LM.LS(for: "unit"), selection: $selectedUnit) {
              ForEach(units, id: \.self) { unit in
                Text(LM.LS(for: unit)).tag(unit)
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
      case .create: return LM.LS(for: "add_title")
      case .edit: return LM.LS(for: "edit_habit")
    }
  }

  private var buttonTitle: String {
    switch mode {
      case .create: return LM.LS(for: "save")
      case .edit: return LM.LS(for: "save")
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
