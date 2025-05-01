//
//  CellView.swift
//  GoalStreak
//
//  Created by Jonas Niyazson on 2025-05-01.
//

import SwiftUI

import SwiftUI

struct CellView<Destination: View>: View {
    let title: String
    let color: Color
    let icon: String
    let destination: Destination

    var body: some View {
        NavigationLink(destination: destination) {
            HStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.largeTitle)
                Text(title)
                    .font(.headline)
                    .multilineTextAlignment(.leading)
            }
            .foregroundColor(.blue)
            .padding()
            .frame(maxWidth: .infinity, minHeight: 80)
            .background(color)
            .cornerRadius(16)
            .shadow(radius: 4)
        }
    }
}

#Preview {
    NavigationStack {
        CellView(
            title: "📖 Läsa boken",
            color: .blue.opacity(0.2),
            icon: "book",
            destination: Text("Demo destination")
        )
        .padding()
    }
}
