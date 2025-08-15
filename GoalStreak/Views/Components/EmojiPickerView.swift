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
    // MARK: - Environment
    @EnvironmentObject var LM: LocalizationManager

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            
            // Fördefinierade emojis
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
          Divider()
          
          // Systemets emoji-tangentbord via TextField
          HStack {
            Text(LM.localizedString(for:"custom_emoji"))
            Spacer()
            TextField("😀", text: $selectedEmoji)
                .font(.largeTitle)
                .textFieldStyle(.roundedBorder)
                .frame(maxWidth: 80)
                .keyboardType(.default)
          }
          
        }
    }
}

// MARK: - PREVIEW
#Preview {
    EmojiPickerView(
        selectedEmoji: .constant("⏰"),
        availableEmojis: ["🎯", "📚", "🏃‍♂️", "🧘‍♀️", "💧", "📝", "💪", "🧹", "🍎", "🎨", "📅", "⏰"]
    )
    .background(.gray.opacity(0.2))
    .environmentObject(LocalizationManager())
}

