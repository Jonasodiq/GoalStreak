//
//  ColorPickerView.swift
//  GoalStreak
//
//  Created by Jonas Niyazson on 2025-05-07.
//

import SwiftUI

struct ColorPickerView: View {
  
    // MARK: - PROPERTIES
    let predefinedColors: [String: Color]
    @Binding var selectedColorHex: String
    @Binding var customColor: Color

    // MARK: - BODY
    var body: some View {
      VStack(alignment: .leading, spacing: 12) {
        Text("Välj färg").font(.headline)

        HStack(spacing: 8) {
          ForEach(predefinedColors.sorted(by: { $0.key < $1.key }), id: \.key) { hex, color in
            Circle()
            .fill(color)
            .frame(width: 30, height: 30)
            .overlay(
              Circle()
                .stroke(Color.black, lineWidth: selectedColorHex == hex ? 2 : 0)
            )
            .onTapGesture {
              selectedColorHex = hex
              customColor = color
            }
          }
        }
        // MARK: - Picker
        ColorPicker("Anpassad färg", selection: $customColor)
          .onChange(of: customColor) {
            SoundPlayer.play("pop")
            selectedColorHex = customColor.toHex() ?? "#007AFF"
          }
      }
      .padding()
    }
}

// MARK: - PREVIEW
#Preview {
  @Previewable @State var hex = "#007AFF"
  @Previewable @State var color = Color.blue

    return ColorPickerView(
        predefinedColors: Color.predefinedGoalColors,
        selectedColorHex: $hex,
        customColor: $color
    )
    .background(.gray.opacity(0.2))
}
