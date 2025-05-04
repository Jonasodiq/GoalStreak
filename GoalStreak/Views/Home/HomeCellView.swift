//
//  CellView.swift
//  GoalStreak
//
//  Created by Jonas Niyazson on 2025-05-01.
//

import SwiftUI

struct HomeCellView<Destination: View>: View {
  let title: String
  let color: Color
  let icon: String
  let destination: Destination

  var body: some View {
    NavigationLink(destination: destination) {
      HStack(spacing: 12) {
        
        Text(icon)
          .font(.system(size: 32, weight: .bold, design: .monospaced))

        Text(title)
          .font(.headline)
          .foregroundColor(.primary)
          .multilineTextAlignment(.leading)
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
  HomeCellView(title: "Test", color: .blue.opacity(0.2), icon: "🔹",
               destination: Text("Test"))
}
