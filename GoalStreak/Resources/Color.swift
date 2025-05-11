//
//  Color.swift
//  GoalStreak
//
//  Created by Jonas Niyazson on 2025-05-02.
//

import SwiftUI

extension Color {
  
    /// Initializes a `Color` from a hex string, e.g. "#FF0000"
    init?(hex: String?) {
        guard let hex = hex else { return nil }
        var hexFormatted = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if hexFormatted.hasPrefix("#") {
            hexFormatted.removeFirst()
        }

        guard hexFormatted.count == 6,
              let rgb = Int(hexFormatted, radix: 16) else { return nil }

        let r = Double((rgb >> 16) & 0xFF) / 255.0
        let g = Double((rgb >> 8) & 0xFF) / 255.0
        let b = Double(rgb & 0xFF) / 255.0

        self.init(red: r, green: g, blue: b)
    }

    /// Converts a `Color` to a hex string, e.g. "#FF0000"
    func toHex() -> String? {
        let uiColor = UIColor(self)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0

        guard uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        else { return nil }

        return String(
            format: "#%02X%02X%02X",
            Int(red * 255),
            Int(green * 255),
            Int(blue * 255)
        )
    }
    
    /// Predefined colors for targets
    static let predefinedGoalColors: [String: Color] = [
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
}
