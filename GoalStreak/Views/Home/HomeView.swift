//
//  HomeView.swift
//  GoalStreak
//
//  Created by Jonas Niyazson on 2025-05-01.
//

import SwiftUI

struct HomeView: View {
  @EnvironmentObject var authViewModel: AuthViewModel
  let goalViewModel: GoalViewModel

    var body: some View {
      NavigationStack {
        ScrollView {
          VStack(spacing: 16) {
            HomeListView(
              title: "🎯 Mina mål",
              color: .cyan.opacity(0.3),
              icon: "target",
              destination: ListView(viewModel: goalViewModel)
            )
            HomeListView(
              title: "📊 Statistik (kommer)",
              color: .orange.opacity(0.3),
              icon: "chart.bar",
              destination: Text("Statistikvy kommer senare")
            )
          } //: - VStack
          .padding()
        } //: - Scroll
        .navigationTitle("GoalStreak")
        .toolbar {
          ToolbarItem(placement: .navigationBarTrailing) {
            Button(action: {
                authViewModel.signOut()
            }) {
                Image(systemName: "rectangle.portrait.and.arrow.forward")
                    .foregroundColor(.blue)
            }
          }
        }
      } //: - Nav
    } //: - Body
}

#Preview {
    HomeView(goalViewModel: GoalViewModel())
}
