//
//  HomeListView.swift
//  GoalStreak
//
//  Created by Jonas Niyazson on 2025-05-01.
//

import SwiftUI

struct HomeListView<Destination: View>: View {
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
            }
            .foregroundColor(.white)
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
        HomeListView(
            title: "📖 Nya böcker",
            color: .blue,
            icon: "book.fill",
            destination: Text("Demo destination")
        )
        .padding()
    }
}
