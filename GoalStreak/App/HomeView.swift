//
//  ContentView.swift
//  GoalStreak
//
//  Created by Jonas Niyazson on 2025-04-29.
//

import SwiftUI
import AVFoundation

struct HomeView: View {
    @EnvironmentObject var goalViewModel: GoalViewModel
    @State private var selectedTab = 0
    @State private var audioPlayer: AVAudioPlayer?
    
    var body: some View {
      ZStack {
        TabView(selection: $selectedTab) {
          HomeListView()
            .tabItem {Image(systemName: "house")}
            .tag(0)
          
          StatsView()
            .tabItem {Image(systemName: "calendar.badge.checkmark")}
            .tag(1)
          
          GoalFormView(mode: .create, selectedTab: $selectedTab)
            .tabItem {EmptyView()}
            .tag(2)
          
          GroupView()
            .tabItem {Image(systemName: "person.3")}
            .tag(3)

          SettingsView()
            .tabItem {Image(systemName: "gearshape")}
            .tag(4)
        } //: - TabView
        
        VStack {
          Spacer()
          HStack {
            Spacer()
            Button(action: {
                SoundPlayer.play("pop")
                selectedTab = 2
            }) {
              Image(systemName: "plus.circle.fill")
                .resizable()
                .frame(width: 60, height: 60)
                .foregroundColor(selectedTab == 2 ? .blue : .gray.opacity(0.5))
                .background(Color.white.clipShape(Circle()))
            }
            .offset(y: -8)
            
            Spacer()
          }
        } //: - VStack
        .onChange(of: selectedTab) { oldValue, newValue in
          SoundPlayer.play("pop")
        }
      } //: - ZStack
    } //: - Body
}

#Preview {
    HomeView()
        .environmentObject(GoalViewModel())
        .environmentObject(LocalizationManager())
}

/**
 🎨 2. UI/UX (Användarupplevelse)
 ✅ Styrkor
 Appen är färgrik, har tydlig visuell hierarki och tilltalande grafik.
 Feedback genom ljud, animationer och notiser höjer känslan av belöning.
 Stöd för ljus/mörkt läge och flerspråkighet är utmärkt.
 ⚠️ Förbättringsförslag
 Del                       Förslag
 Målformulär          Visa realtidsfeedback ("Ogiltigt värde" eller "Målvärde krävs") under textfältet
 TimerView            Visa en mer tydlig "paus"-status när timern är inaktiv (grå overlay t.ex.)
 HomeListView      Låt användaren filtrera på kategori/emoji eller taggar, inte bara sortera
 Accessibility        Använd accessibilityLabel och VoiceOver-stöd för användare med nedsatt syn
 För nybörjare      Lägg till onboarding/instruktionsvy för nya användare om vad "streaks" är
 */


/**
 🧪 3. Testbarhet & Strukturförbättringar
 ✅ Bra design
 Du använder @EnvironmentObject, vilket underlättar testning av vyer i isolation.

 ⚠️ Förbättringsmöjligheter
 Del                    Problem                                                                    Förslag
 ViewModel        All Firebase-logik är inbakad i GoalViewModel        Bryt ut datalager i en egen klass (e.g. GoalRepository) för lättare mockning/test
 Tester               Ingen enhetstestning i sikte                                      Skriv tester för AuthViewModel, GoalViewModel och GoalLogic (t.ex. streakberäkning)
 UI Tester           Du kan dra nytta av @testable import och XCTest för integrationstester med TimerView, GoalFormView
 Mock Data        Skapa en MockGoalViewModel och MockAuthViewModel för previews och tester
 */


/**
 🧭 Nästa steg: Rekommenderade åtgärder
 ✅ Akuta förbättringar:

 Rätta datumjämförelsebugg
 Lägg till felhantering i UI för Firebase-fel
 Begränsa åtkomst via Firestore Security Rules

 🚀 Nästa nivå:

 Inför testbar datalagerstruktur (GoalRepository)
 Lägg till Unit Tests och UI Tests
 Förbättra formulärvalidering och inputfeedback
 Lägg till onboarding eller hjälpfunktion för nya användare


 */
