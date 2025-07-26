//
//  HomeListView.swift
//  GoalStreak
//
//  Created by Jonas Niyazson on 2025-05-01.
//

import SwiftUI
import FirebaseFirestore
import AVFoundation

enum FilterSortOption: String, CaseIterable, Identifiable {
    case name = "Namn"
    case streak = "Streak"
    case progress = "Framsteg"
    case hideCompleted = "Göm slutförda"

    var id: String { self.rawValue }
}

struct HomeListView: View {

    // MARK: - Environment
    @EnvironmentObject var goalViewModel: GoalViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var LM: LocalizationManager

    // MARK: - State
    @State private var selectedOption: FilterSortOption = .name
    @State private var audioPlayer: AVAudioPlayer?
    @State private var showLogoutConfirmation = false

    // MARK: - Filtered & sorted Streaks
    var visibleGoals: [Goal] {
          let filtered = selectedOption == .hideCompleted
              ? goalViewModel.goals.filter { !$0.isCompleted }
              : goalViewModel.goals

          switch selectedOption {
          case .name:
              return filtered.sorted { $0.name.lowercased() < $1.name.lowercased() }
          case .streak:
              return filtered.sorted { $0.streak > $1.streak }
          case .progress:
              return filtered.sorted {
                  let p0 = Double($0.currentValue ?? 0) / Double($0.goalValue ?? 1)
                  let p1 = Double($1.currentValue ?? 0) / Double($1.goalValue ?? 1)
                  return p0 > p1
              }
          case .hideCompleted:
              return filtered.sorted { $0.name.lowercased() < $1.name.lowercased() } // fallback sort
          }
      }

    // MARK: - BODY
    var body: some View {
        NavigationStack {
            VStack {
              // MARK: Picker
              Picker("Sortering", selection: Binding(
                  get: { selectedOption },
                  set: { newValue in
                    selectedOption = newValue
                    SoundPlayer.play("pop")
                  }
              )) {
                  ForEach(FilterSortOption.allCases) { option in
                      Text(option.rawValue).tag(option)
                  }
              }
              .pickerStyle(.segmented)
              .padding()

              List {
                ForEach(visibleGoals) { goal in
                  HomeCellView(
                      title: goal.name,
                      subtitle: goal.description,
                      streak: goal.streak,
                      color: Color(hex: goal.colorHex) ?? .blue.opacity(0.2),
                      icon: goal.emoji,
                      currentValue: goal.currentValue ?? 1,
                      goalValue: goal.goalValue ?? 5,
                      valueUnit: goal.valueUnit ?? "count",
                      destination: GoalProgressView(goal: goal)
                    )
                    .listRowBackground(Color.clear)
                  }
                .onDelete(perform: delete)
              }
              .listStyle(PlainListStyle())
            }
            .navigationTitle(LM.localizedString(for: "habits_title"))
          // MARK: - Log out
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        SoundPlayer.play("pop")
                        showLogoutConfirmation = true
                    }) {
                        Image(systemName: "rectangle.portrait.and.arrow.forward")
                            .foregroundColor(.blue)
                    }
                }
            }
            // MARK: - Log out alert
            .alert(LM.localizedString(for: "logout_title"), isPresented: $showLogoutConfirmation) {
                Button(LM.localizedString(for: "logout_confirm"), role: .destructive) {
                    SoundPlayer.play("pop")
                    authViewModel.signOut()
                    goalViewModel.clearGoals()
                }
                Button(LM.localizedString(for: "cancel"), role: .cancel) {}
            } message: {
                Text(LM.localizedString(for: "logout_message"))
            }
        }
    }

  // MARK: - Sweep Delete List
  func delete(at offsets: IndexSet) {
      for index in offsets {
          let goal = visibleGoals[index]
          goalViewModel.deleteGoal(goal)
      }
    SoundPlayer.play("vand-blad-1")
  }
}

// MARK: - PREVIEW
#Preview() {
    HomeListView()
    .environmentObject(GoalViewModel())
    .environmentObject(LocalizationManager())
}


/**
 1. Förbättra filtrering och sortering
 Just nu kan användaren välja mellan att sortera mål efter namn, streak, eller progress. Det kan vara bra att även ha en filter-funktion där användaren kan välja att visa mål baserat på deras status. T.ex. visa bara mål som är "completed" eller bara mål som är "in progress". Du har redan en viss filtrering genom selectedOption, men du kan kanske göra det mer tydligt och lättillgängligt för användaren.

 Förslag på förbättring:
 Lägg till en extra picker för att välja mellan olika filter (t.ex. "All", "Completed", "In Progress").
 
 Picker("Filter", selection: Binding(
     get: { selectedOption },
     set: { newValue in
         selectedOption = newValue
         SoundPlayer.play("pop")
     }
 )) {
     Text("All").tag(FilterSortOption.all)
     Text("Completed").tag(FilterSortOption.hideCompleted)
     Text("In Progress").tag(FilterSortOption.inProgress)
 }
 .pickerStyle(.segmented)
 .padding()
 
 enum FilterSortOption: String, CaseIterable, Identifiable {
     case name, streak, progress, hideCompleted, inProgress, all

     var id: String { rawValue }
 }

 
 
 4. Lägg till mer interaktivitet i listan
 För att ge användaren möjlighet att interagera mer med sina mål, kan du överväga att lägga till funktioner som att markera mål som slutförda direkt från listan eller ta bort mål.

 För att implementera markering av mål som slutförda:
 Button(action: {
     goal.isCompleted.toggle()
     goalViewModel.updateGoal(goal)
 }) {
     Text(goal.isCompleted ? "Mark as In Progress" : "Mark as Completed")
         .foregroundColor(.blue)
 }

 
 5. Användarfeedback
 Ge feedback när användaren interagerar med appen. När du raderar ett mål eller markerar det som slutfört, ge en visuell indikator som en toast eller alert.
 
 6. Lägg till en sökfunktion
 Det kan vara användbart att lägga till en sökfunktion där användaren kan söka efter mål baserat på namn eller beskrivning.
 Exempel på att lägga till en sökfunktion i listan:
 @State private var searchText = ""

 var body: some View {
     VStack {
         TextField("Search Goals", text: $searchText)
             .padding()
             .textFieldStyle(RoundedBorderTextFieldStyle())
         
         List {
             ForEach(visibleGoals.filter { goal in
                 goal.name.lowercased().contains(searchText.lowercased())
             }) { goal in
                 HomeCellView(
                     title: goal.name,
                     subtitle: goal.description,
                     streak: goal.streak,
                     color: Color(hex: goal.colorHex) ?? .blue.opacity(0.2),
                     icon: goal.emoji,
                     currentValue: goal.currentValue ?? 1,
                     goalValue: goal.goalValue ?? 5,
                     valueUnit: goal.valueUnit ?? "count",
                     destination: GoalProgressView(goal: goal)
                 )
                 .listRowBackground(Color.clear)
             }
         }
     }
 }
 
 7. Några andra idéer:
 Animationer: Lägg till små animationer när mål uppdateras eller när användaren interagerar med element (t.ex. när ett mål markeras som slutfört).

 Gamification: Lägg till belöningssystem som t.ex. badges eller medaljer när användaren når sina mål.

 */
