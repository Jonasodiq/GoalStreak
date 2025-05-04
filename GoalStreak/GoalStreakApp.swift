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
            .environmentObject(authViewModel)
            .environmentObject(goalViewModel)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}
