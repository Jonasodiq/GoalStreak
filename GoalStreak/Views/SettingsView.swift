//
//  SettingsView.swift
//  GoalStreak
//
//  Created by Jonas Niyazson on 2025-05-03.
//

import SwiftUI

struct SettingsView: View {
  @EnvironmentObject var authViewModel: AuthViewModel
  @EnvironmentObject var goalViewModel: GoalViewModel
  @EnvironmentObject var localizationManager: LocalizationManager
  @State private var notificationsEnabled = true
  @AppStorage("selectedAppearance") private var selectedAppearance: String = "system"
  @AppStorage("selectedLanguage") private var selectedLanguage = "sv"


  enum AppearanceOption: String, CaseIterable, Identifiable {
      case light, dark, system
      
      var id: String { self.rawValue }
      func localizedLabel(using manager: LocalizationManager) -> String {
          switch self {
          case .light:
              return manager.localizedString(for: "light_mode")
          case .dark:
              return manager.localizedString(for: "dark_mode")
          case .system:
              return manager.localizedString(for: "system_mode")
          }
      }
  }

  
  var body: some View {
    NavigationStack {
      List {

        // MARK: - SECTION: ACCOUNT
        Section(header: Text(localizationManager.localizedString(for: "account_section"))) {
          Button(action: {
              print("Byt lösenord tryckt")
          }) {
              ListRowView(
                rowLabel: localizationManager.localizedString(for: "change_password"),
                rowIcon: "key.fill",
                rowTintColor: .blue
              )
          }

          Button(role: .destructive, action: {
              print("Ta bort konto tryckt")
          }) {
              ListRowView(
                rowLabel: localizationManager.localizedString(for: "delete_account"),
                rowIcon: "trash.fill",
                rowTintColor: .red
              )
          }
        }

        // MARK: - SECTION: NOTIFICATIONS
        Section(header: Text(localizationManager.localizedString(for: "notice_section"))) {
          Toggle(isOn: $notificationsEnabled) {
            ListRowView(
              rowLabel: localizationManager.localizedString(for: "daily_reminders"),
              rowIcon: "bell.badge.fill",
              rowTintColor: .orange
            )
          }
        }

        // MARK: - SECTION: SPRÅK
        Section(header: Text(localizationManager.localizedString(for: "language_section"))) {
          Picker(localizationManager.localizedString(for: "language_section"), selection: $selectedLanguage) {
            Text(localizationManager.localizedString(for: "swedish")).tag("sv")
            Text(localizationManager.localizedString(for: "english")).tag("en")
          }
          .pickerStyle(.inline)
        }

        // MARK: - SECTION: UTSEENDE
        Section(header: Text(localizationManager.localizedString(for: "appearance_section"))) {
          Picker(localizationManager.localizedString(for: "color_theme"), selection: $selectedAppearance) {
            ForEach(AppearanceOption.allCases) { option in
              Text(option.localizedLabel(using: localizationManager))
                .tag(option.rawValue)
            }
          }
          .pickerStyle(.inline)
        }

        // MARK: - SECTION: ABOUT
        Section(
          header: Text(localizationManager.localizedString(for: "about_section")),
          footer: copyrightFooter
        ) {
          ListRowView(
            rowLabel: localizationManager.localizedString(for: "application"),
            rowIcon: "apps.iphone",
            rowContent: "Goal Streak",
            rowTintColor: .indigo
          )

          ListRowView(
            rowLabel: localizationManager.localizedString(for: "compatibility"),
            rowIcon: "info.circle",
            rowContent: "iOS, iPadOS",
            rowTintColor: .mint
          )

          ListRowView(
            rowLabel: localizationManager.localizedString(for: "technology"),
            rowIcon: "swift",
            rowContent: "Swift",
            rowTintColor: .orange
          )

          ListRowView(
            rowLabel: "Version",
            rowIcon: "gear",
            rowContent:  "1.0",
            rowTintColor: .purple
          )

          ListRowView(
            rowLabel: localizationManager.localizedString(for: "developer"),
            rowIcon: "ellipsis.curlybraces",
            rowContent: "Jonas Niyazson",
            rowTintColor: .brown
          )

          ListRowView(
            rowLabel: "Designer",
            rowIcon: "paintpalette",
            rowContent: "John Doe",
            rowTintColor: .pink
          )

          ListRowView(
            rowLabel: localizationManager.localizedString(for: "website_label"),
            rowIcon: "globe",
            rowTintColor: .blue,
            rowLinkLabel: "My Portfolio",
            rowLinkDestination: "https://my-easy-portfolio.netlify.app/"
          )

          ListRowView(
            rowLabel:"Linkedin",
            rowIcon: "person.text.rectangle",
            rowTintColor: .blue,
            rowLinkLabel: "Jonas Niyazson",
            rowLinkDestination: "https://www.linkedin.com/in/jonas-niyazson-4972b11b0/"
          )
        }
      }
      .navigationTitle(localizationManager.localizedString(for: "settings_title"))
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          Button(action: {
            authViewModel.signOut()
            goalViewModel.clearGoals()
          }) {
              Image(systemName: "rectangle.portrait.and.arrow.forward")
                  .foregroundColor(.blue)
          }
        }
      }
    }
  }

  // MARK: - FOOTER
  var copyrightFooter: some View {
    HStack {
      Spacer()
      Text(localizationManager.localizedString(for: "copyright_footer"))
        .multilineTextAlignment(.center)
      Spacer()
    }
    .padding(.vertical, 8)
  }
}

// MARK: - PREVIEW
#Preview {
    SettingsView()
    .environmentObject(AuthViewModel())
    .environmentObject(GoalViewModel())
    .environmentObject(LocalizationManager())
}
