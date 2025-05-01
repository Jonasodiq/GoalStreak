//
//  ProgressListView.swift
//  GoalStreak
//
//  Created by Jonas Niyazson on 2025-04-29.
//

import SwiftUI

struct ListView: View {
    @ObservedObject var viewModel: GoalViewModel

    var body: some View {
      ZStack {
        List(viewModel.goals) { goal in
          Button(action: {
            viewModel.completeGoal(goal)
          }) {
            ZStack(alignment: .leading) {
              GeometryReader { geometry in
                let progress = min(Double(goal.streak) / 7.0, 1.0)
                Rectangle()
                  .fill(Color.blue.opacity(0.2))
                  .frame(width: geometry.size.width * progress)
                  .animation(.easeInOut(duration: 0.3), value: progress)
              }
              
              HStack {
                Image(systemName: "book")
                  .foregroundColor(.cyan)
                  .font(.system(size: 28))
            
                VStack(alignment: .leading) {
                  
                  Text(goal.name)
                    .font(.headline)
                  Text("🔥 Streak: \(goal.streak)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                }
                
                Spacer()
                
                if viewModel.isCompletedToday(goal) {
                  Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
                } else {
                  Image(systemName: "circle")
                    .foregroundColor(.gray)
                }
              }
              .padding(.horizontal, 4)
            }
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .frame(height: 60)
            
          }
//          .background(.gray.opacity(0.3))
//          .cornerRadius(10)
          
        }
//        .listStyle(.plain)

      }
      
    }
}

// MARK: - PREVIEW

#Preview {
  ListView(viewModel: GoalViewModel())
}
