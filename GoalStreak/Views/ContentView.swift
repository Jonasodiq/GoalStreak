//
//  ContentView.swift
//  GoalStreak
//
//  Created by Jonas Niyazson on 2025-04-29.
//

import SwiftUI
import Firebase

struct ContentView: View {
    @StateObject var goalViewModel = GoalViewModel()

    var body: some View {
        TabView {
            HomeView(goalViewModel: goalViewModel)
                .tabItem {
                    Image(systemName: "house")
                    Text("Start")
                }

            ListView(viewModel: goalViewModel)
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Mål")
                }

            Text("Inställningar (kommer)")
                .tabItem {
                    Image(systemName: "gearshape")
                    Text("Inställningar")
                }
        }
    }
}

// MARK: - PREVIEW
#Preview {
    ContentView()
}
