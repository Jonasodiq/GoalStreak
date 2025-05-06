//
//  AddGoalView.swift
//  GoalStreak
//
//  Created by Jonas Niyazson on 2025-05-02.
//

import SwiftUI

struct AddGoalView: View {
    @EnvironmentObject var goalViewModel: GoalViewModel
    @EnvironmentObject var LM: localizationManager
    @Binding var selectedTab: Int

    @State private var goalName = ""
    @State private var goalDescription = ""
    @State private var groupName = ""
    @State private var emoji = "🎯"
    @State private var selectedColor = Color.blue
    @State private var selectedEmoji = "🎯"

    @State private var selectedPeriod: GoalPeriod = .dayLong
    @State private var goalValue: String = ""
    @State private var selectedUnit: String = "count"

    let availableEmojis = ["🎯", "📚", "🏃‍♂️", "🧘‍♀️", "💧", "📝", "💪", "🧹", "🍎", "🎨", "📅", "⏰"]
    let units = ["count", "steps", "km", "mile", "sec", "min", "hr", "ml", "oz", "Cal", "g", "mg"]
    let periods: [GoalPeriod] = [.dayLong, .weekLong, .monthLong]

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
              
                Text(LM.localizedString(for: "add_title")).font(.headline)

                TextField(LM.localizedString(for: "text_field"), text: $goalName)
                    .textFieldStyle(.roundedBorder)

                TextField("Beskrivning", text: $goalDescription)
                    .textFieldStyle(.roundedBorder)

                TextField("Grupp (valfritt)", text: $groupName)
                    .textFieldStyle(.roundedBorder)

                // Emoji-väljare
                Text(LM.localizedString(for: "choose_emoji")).font(.headline)
                LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 6), spacing: 10) {
                  ForEach(availableEmojis, id: \.self) { emoji in
                  Text(emoji)
                    .font(.largeTitle)
                    .padding(8)
                    .background(selectedEmoji == emoji ? Color.blue.opacity(0.3) : Color.clear)
                    .clipShape(Circle())
                    .onTapGesture {
                        selectedEmoji = emoji
                    }
                  }
                }

                ColorPicker(LM.localizedString(for: "choose_color"), selection: $selectedColor)

                // Period
                Picker("Period", selection: $selectedPeriod) {
                    ForEach(periods, id: \.self) { period in
                        Text(period.rawValue)
                    }
                }.pickerStyle(.segmented)

                // Värde & enhet
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

                Button(LM.localizedString(for: "save")) {
                  let hex = selectedColor.toHex() ?? "#2196F3"
                  let valueDouble = Double(goalValue)

                  // Kontrollera om målvärdet
                  guard let goalValueDouble = valueDouble else {
                      return
                  }

                  // Lägg till målet till goalViewModel
                  goalViewModel.addGoal(
                      name: goalName,
                      description: goalDescription,
                      group: groupName.isEmpty ? "" : groupName,
                      emoji: selectedEmoji,
                      colorHex: hex,
                      period: selectedPeriod,
                      goalValue: goalValueDouble,
                      valueUnit: selectedUnit
                  )

                  // Byt till första fliken (HomeListView)
                  selectedTab = 0
                }
                .disabled(goalName.isEmpty || Double(goalValue) == nil)
                .buttonStyle(.borderedProminent)

                Spacer()
            }
            .padding()
        }
    }
}

// MARK: - PREVIEW
#Preview {
    AddGoalView(selectedTab: .constant(1))
        .environmentObject(GoalViewModel())
        .environmentObject(localizationManager())
}
