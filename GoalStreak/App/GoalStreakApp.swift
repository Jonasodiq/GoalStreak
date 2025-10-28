//
//  GoalStreakApp.swift
//  GoalStreak
//
//  Created by Jonas Niyazson on 2025-04-29.
//

import SwiftUI
import Firebase

@main
struct GoalStreakApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var authViewModel = AuthViewModel()
    @StateObject var goalViewModel = GoalViewModel()
    @AppStorage("selectedAppearance") var selectedAppearance: String = "system"
    @StateObject var LM = LocalizationManager()

    var colorScheme: ColorScheme? {
        switch selectedAppearance {
        case "light": return .light
        case "dark": return .dark
        default: return nil
        }
    }


    var body: some Scene {
        WindowGroup {
            Group {
              if authViewModel.user != nil {
              HomeView()
                .onAppear {
                    goalViewModel.fetchGoals()
                }
              } else {
                LoginView()
              }
            }
            .preferredColorScheme(colorScheme)
            .environmentObject(authViewModel)
            .environmentObject(goalViewModel)
            .environmentObject(LM)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions:[UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}
