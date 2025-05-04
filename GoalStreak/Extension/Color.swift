//
//  Color.swift
//  GoalStreak
//
//  Created by Jonas Niyazson on 2025-05-02.
//

import SwiftUI

extension Color {
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
}

