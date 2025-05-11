//
//  EmojiPickerView.swift
//  GoalStreak
//
//  Created by Jonas Niyazson on 2025-05-08.
//

import SwiftUI

struct EmojiPickerView: View {
  @Binding var selectedEmoji: String
  let availableEmojis: [String]

  var body: some View {
    ScrollView(.horizontal, showsIndicators: false) {
      HStack(spacing: 12) {
        ForEach(availableEmojis, id: \.self) { emoji in
          Text(emoji)
          .font(.largeTitle)
          .padding(8)
          .background(
            Circle()
            .fill(selectedEmoji == emoji ? Color.blue.opacity(0.2) : Color.clear)
          )
          .onTapGesture {
            SoundPlayer.play("pop")
            selectedEmoji = emoji
          }
        }
      }
      .padding(.vertical, 4)
    }
  }
}

// MARK: - PREVIEW
#Preview {
    EmojiPickerView(
        selectedEmoji: .constant("🎯"),
        availableEmojis: ["🎯", "📚", "🏃‍♂️", "🧘‍♀️", "💧", "📝", "💪", "🧹", "🍎", "🎨", "📅", "⏰"]
    )
    .background(.gray.opacity(0.2))
}
