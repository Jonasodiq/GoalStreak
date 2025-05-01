//
//  GoalStreakApp.swift
//  GoalStreak
//
//  Created by Jonas Niyazson on 2025-04-29.
//

import SwiftUI
import FirebaseCore

// Startar Firebase
class AppDelegate: NSObject, UIApplicationDelegate { // en traditionell AppDelegate
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main // Huvudingången till app
struct GoalStreakApp: App {
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
  @StateObject var authViewModel = AuthViewModel()
  
    var body: some Scene {
        WindowGroup {
          Group {
                 if authViewModel.user != nil {
                     ContentView()
                 } else {
                     LoginView()
                 }
             }
             .animation(.easeInOut, value: authViewModel.user)
             .environmentObject(authViewModel)
        }
    }
}
