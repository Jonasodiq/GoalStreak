//
//  CellView.swift
//  GoalStreak
//
//  Created by Jonas Niyazson on 2025-05-01.
//

import SwiftUI

struct HomeCellView<Destination: View>: View {
  let title: String
  let subtitle: String?
  let streak: Int
  let color: Color
  let icon: String
  let currentValue: Double = 1      // uppnått värde
  let goalValue: Double = 5         // mål
  let valueUnit: String = "count"   // enhet
  let destination: Destination
  
  var body: some View {
    NavigationLink(destination: destination) {
      HStack(spacing: 12) {
        
        Text(icon)
          .font(.system(size: 32, weight: .bold, design: .monospaced))

        VStack(alignment: .leading, spacing: 4) {
          Text(title)
            .font(.headline)
            .foregroundColor(.primary)
                     
          if let subtitle = subtitle, !subtitle.isEmpty {
              Text(subtitle)
                  .font(.caption)
                  .foregroundColor(.secondary)
          }
        }
        
        Spacer()
        
        VStack(alignment: .trailing, spacing: 4) {
          Text( "🎯 \(streak)")
            .font(.caption)
            .foregroundColor(.secondary)

          Text("\(currentValue.clean)/\(goalValue.clean) \(valueUnit)")
              .font(.caption)
              .foregroundColor(.primary)
        }
      }
      .padding()
      .frame(maxWidth: .infinity, minHeight: 80, alignment: .leading)
      .background(color)
      .cornerRadius(16)
      .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
  }
}

#Preview {
  HomeCellView(
    title: "Title",
    subtitle: "Subtitle",
    streak: 10,
    color: .blue.opacity(0.2),
    icon: "⏱️",
    destination: Text("Test"))
}
