//
//  AddGoalView.swift
//  GoalStreak
//
//  Created by Jonas Niyazson on 2025-05-02.
//

import SwiftUI

struct AddGoalView: View {
    @EnvironmentObject var goalViewModel: GoalViewModel
  @EnvironmentObject var localizationManager: LocalizationManager
    @Environment(\.dismiss) var dismiss
    @State private var goalName = ""
    @State private var emoji = "🎯"
    @State private var selectedColor = Color.blue
    @State private var selectedEmoji = "🎯"
  
  let availableEmojis = ["🎯", "📚", "🏃‍♂️", "🧘‍♀️", "💧", "📝", "💪", "🧹", "🍎", "🎨", "📅", "⏰"]


    var body: some View {
        VStack(spacing: 20) {

          Text(localizationManager.localizedString(for: "add_title")).font(.headline)
          
            TextField(localizationManager.localizedString(for: "text_field"), text: $goalName)
              .textFieldStyle(.roundedBorder)
          
          Text(localizationManager.localizedString(for: "choose_emoji")).font(.headline)
          
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
          .padding(.bottom)


          ColorPicker(localizationManager.localizedString(for: "choose_color"), selection: $selectedColor)


          Button(localizationManager.localizedString(for: "save")) {
            let hex = selectedColor.toHex() ?? "#2196F3"

              goalViewModel.addGoal(name: goalName, emoji: selectedEmoji, colorHex: hex)
              dismiss()
          }
            .disabled(goalName.isEmpty)
            .buttonStyle(.borderedProminent)

            Spacer()
        }
        .padding()
//        .navigationTitle("Lägg till Vana")
    }
}

#Preview {
    AddGoalView()
        .environmentObject(GoalViewModel())
        .environmentObject(LocalizationManager())
}
