//
//  ContentView.swift
//  GoalStreak
//
//  Created by Jonas Niyazson on 2025-04-29.
//

import SwiftUI
import Firebase

struct ContentView: View {
  // MARK: - PROPERTIES
  let db = Firestore.firestore()
  
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .onAppear {db.collection("test").addDocument(data:["name": "Jonas"])}
        .padding()
    }
}

#Preview {
    ContentView()
}
