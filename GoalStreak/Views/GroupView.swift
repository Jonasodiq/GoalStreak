//
//  GroupView.swift
//  GoalStreak
//
//  Created by Jonas Niyazson on 2025-08-14.
//

import SwiftUI

struct GroupView: View {
//  @EnvironmentObject var goalViewModel: GoalViewModel
  
    var body: some View {
      NavigationStack {
        VStack(alignment: .leading, spacing: 16) {
          Text("GroupView")
            .font(.headline)
            .padding(.top)
          
          Spacer()
        }
        .padding()
        .navigationTitle("Group")
      }
    }
  
}

#Preview {
    GroupView()
}
