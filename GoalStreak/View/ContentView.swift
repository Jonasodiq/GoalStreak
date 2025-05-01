//
//  ContentView.swift
//  GoalStreak
//
//  Created by Jonas Niyazson on 2025-04-29.
//

import SwiftUI
import Firebase

struct ContentView: View {
    @StateObject var viewModel = GoalViewModel()
    @State private var newGoal = ""

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    TextField("Nytt mål...", text: $newGoal)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.leading)

                    Button(action: {
                        guard !newGoal.isEmpty else { return }
                        viewModel.addGoal(name: newGoal)
                        newGoal = ""
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.blue)
                            .font(.title)
                    }
                    .padding()
                } //: - HStack End
                

                ListView(viewModel: viewModel)
            } //: - VStack
            .navigationTitle("GoalStreak")
            .background(.gray.opacity(0.3))
        }
    }
}


// MARK: - PREVIEW
#Preview {
    ContentView()
}
