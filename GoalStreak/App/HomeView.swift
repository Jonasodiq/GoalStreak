//
//  ContentView.swift
//  GoalStreak
//
//  Created by Jonas Niyazson on 2025-04-29.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var goalViewModel: GoalViewModel
    @State private var selectedTab = 0  // vilken flik som är vald
    
    var body: some View {
      ZStack {
        TabView(selection: $selectedTab) {
          HomeListView()
          .tabItem {
            Image(systemName: "house")
          }
          .tag(0)
          
          GoalFormView(mode: .create, selectedTab: $selectedTab)
              .tabItem {
                  EmptyView()
              }
              .tag(1)

          SettingsView()
            .tabItem {
                Image(systemName: "gearshape")
            }
            .tag(2)
        } //: - TabView
        
        VStack {
          Spacer()
          HStack {
            Spacer()
            Button(action: {
                selectedTab = 1
            }) {
              Image(systemName: "plus.circle.fill")
                .resizable()
                .frame(width: 60, height: 60)
                .foregroundColor(selectedTab == 1 ? .blue : .gray.opacity(0.5))
                .background(Color.white.clipShape(Circle()))
            }
            .offset(y: -8)
            
            Spacer()
          }
        } //: - VStack
      } //: - ZStack
    } //: - Body
}

#Preview {
    HomeView()
        .environmentObject(GoalViewModel())
        .environmentObject(LocalizationManager())
}


