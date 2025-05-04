//
//  AddGoalView.swift
//  GoalStreak
//
//  Created by Jonas Niyazson on 2025-05-02.
//

import SwiftUI

struct AddGoalView: View {
    @EnvironmentObject var goalViewModel: GoalViewModel
    @Environment(\.dismiss) var dismiss
    @State private var goalName = ""
    @State private var emoji = "🎯"
    @State private var selectedColor = Color.blue
    @State private var selectedEmoji = "🎯"
  
  let availableEmojis = ["🎯", "📚", "🏃‍♂️", "🧘‍♀️", "💧", "📝", "💪", "🧹", "🍎", "🎨", "📅", "⏰"]


    var body: some View {
        VStack(spacing: 20) {
          
          Text("Lägg till en vana").font(.headline)
          
            TextField("Ny vana", text: $goalName)
              .textFieldStyle(.roundedBorder)
          
          Text("Välj en emoji").font(.headline)
          
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


          ColorPicker("Välj färg", selection: $selectedColor)


          Button("Spara") {
            let hex = selectedColor.toHex() ?? "#2196F3"

              goalViewModel.addGoal(name: goalName, emoji: selectedEmoji, colorHex: hex)
              dismiss()
          }
            .disabled(goalName.isEmpty)
            .buttonStyle(.borderedProminent)

            Spacer()
        }
        .padding()
        .navigationTitle("Lägg till Vana")
    }
}

#Preview {
    AddGoalView()
        .environmentObject(GoalViewModel())
}
