//
//  CellView.swift
//  GoalStreak
//
//  Created by Jonas Niyazson on 2025-05-01.
//

import SwiftUI

struct HomeCellView<Destination: View>: View {
  
    // MARK: - PROPERTIES
    let title: String
    let subtitle: String?
    let streak: Int
    let color: Color
    let icon: String
    let currentValue: Double
    let goalValue: Double
    let valueUnit: String
    let destination: Destination
    
    var progress: Double {
        guard goalValue > 0 else { return 0 }
      return min(currentValue / goalValue, 1.0)
    }
    
    var body: some View {
      NavigationLink(destination: destination) {
        GeometryReader { geometry in
          ZStack(alignment: .leading) {
              // BG progress bar
              RoundedRectangle(cornerRadius: 16)
              .fill(color.opacity(0.2))
              
              RoundedRectangle(cornerRadius: 0)
              .fill(color)
                  .frame(width: geometry.size.width * progress)
                  .animation(.easeInOut(duration: 0.6), value: progress)
              
              VStack(spacing: 8) {
                HStack(spacing: 12) {
                  Text(icon)
                    .font(.system(size: 32, weight: .bold, design: .monospaced))
                  
                  VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                      .font(.headline)
                      .foregroundColor(.primary)
                    
                    if let subtitle = subtitle, !subtitle.isEmpty {
                      let maxLength = 22
                      let shortSubtitle = subtitle.count > maxLength
                        ? String(subtitle.prefix(maxLength)) + "..."
                        : subtitle
                      
                      Text(shortSubtitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    }
                  }
                  
                  Spacer()
                  
                  VStack(alignment: .trailing, spacing: 4) {
                    Text("🎯 \(streak)")
                      .font(.caption)
                      .foregroundColor(.secondary)
                    
                    Text("\(currentValue, specifier: "%.0f")/\(goalValue, specifier: "%.0f") \(valueUnit)")
                      .font(.caption)
                      .foregroundColor(.primary)
                  } //: - VStack
                } //: - HStack
              } //: - VStack
              .padding()
              .frame(maxWidth: .infinity, minHeight: 80, alignment: .leading)
          } //: - ZStack
          .cornerRadius(16)
          .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
        }
        .frame(height: 80)
      }
    }
}

// MARK: - PREVIEW
#Preview {
    HomeCellView(
        title: "Löpning",
        subtitle: "Veckomål",
        streak: 5,
        color: .green.opacity(0.2),
        icon: "🏃‍♂️",
        currentValue: 3.5,
        goalValue: 5.0,
        valueUnit: "km",
        destination: Text("Detaljer")
    )
}

