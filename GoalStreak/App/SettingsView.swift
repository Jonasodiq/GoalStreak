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
    @EnvironmentObject var LM: LocalizationManager

    @State private var notificationsEnabled = false
    @State private var showChangePasswordView = false
    @State private var showDeleteAccountView = false

    @AppStorage("selectedAppearance") private var selectedAppearance: String = "system"
    @AppStorage("selectedLanguage") private var selectedLanguage = "sv"

    enum AppearanceOption: String, CaseIterable, Identifiable {
      case light, dark, system
      var id: String { self.rawValue }

      func localizedLabel(using manager: LocalizationManager) -> String {
        switch self {
        case .light: return manager.localizedString(for: "light_mode")
        case .dark: return manager.localizedString(for: "dark_mode")
        case .system: return manager.localizedString(for: "system_mode")
        }
      }
    }

    var body: some View {
        NavigationStack {
        List {
          // MARK: - Konto
          Section(header: Text(LM.localizedString(for: "account_section"))) {
              Button {
                  showChangePasswordView = true
              } label: {
                  ListRowView(
                    rowLabel: LM.localizedString(for: "change_password"),
                    rowIcon: "key.fill",
                    rowTintColor: .blue
                  )
                }

                Button(role: .destructive) {
                  showDeleteAccountView = true
                } label: {
                  ListRowView(
                    rowLabel: LM.localizedString(for: "delete_account"),
                    rowIcon: "trash.fill",
                    rowTintColor: .red
                  )
                }
            }

            // MARK: - Notiser
            Section(header: Text(LM.localizedString(for: "notice_section"))) {
              Toggle(isOn: $notificationsEnabled) {
                ListRowView(
                  rowLabel: LM.localizedString(for: "daily_reminders"),
                  rowIcon: "bell.badge.fill",
                  rowTintColor: .orange
                )
              }
            }

            // MARK: - Språk
            Section(header: Text(LM.localizedString(for: "language_section"))) {
            Picker(LM.localizedString(for: "language_section"), selection: $selectedLanguage) {
                Text(LM.localizedString(for: "swedish")).tag("sv")
                Text(LM.localizedString(for: "english")).tag("en")
              }
              .pickerStyle(.inline)
            }

            // MARK: - Utseende
            Section(header: Text(LM.localizedString(for: "appearance_section"))) {
            Picker(LM.localizedString(for: "color_theme"), selection: $selectedAppearance) {
                ForEach(AppearanceOption.allCases) { option in
                    Text(option.localizedLabel(using: LM))
                        .tag(option.rawValue)
                }
              }
              .pickerStyle(.inline)
            }

            // MARK: - Om appen
            Section(header: Text(LM.localizedString(for: "about_section")), footer: copyrightFooter) {
            ListRowView(rowLabel: LM.localizedString(for: "application"), rowIcon: "apps.iphone", rowContent: "Goal Streak", rowTintColor: .indigo)
            ListRowView(rowLabel: LM.localizedString(for: "compatibility"), rowIcon: "info.circle", rowContent: "iOS, iPadOS", rowTintColor: .mint)
            ListRowView(rowLabel: LM.localizedString(for: "technology"), rowIcon: "swift", rowContent: "Swift", rowTintColor: .orange)
            ListRowView(rowLabel: "Version", rowIcon: "gear", rowContent: "1.0", rowTintColor: .purple)
            ListRowView(rowLabel: LM.localizedString(for: "developer"), rowIcon: "ellipsis.curlybraces", rowContent: "Jonas Niyazson", rowTintColor: .brown)
            ListRowView(rowLabel: LM.localizedString(for: "website_label"), rowIcon: "globe", rowTintColor: .blue, rowLinkLabel: "My Portfolio", rowLinkDestination: "https://my-easy-portfolio.netlify.app/")
            ListRowView(rowLabel: "Linkedin", rowIcon: "person.text.rectangle", rowTintColor: .blue, rowLinkLabel: "Jonas Niyazson", rowLinkDestination: "https://www.linkedin.com/in/jonas-niyazson-4972b11b0/")
          }
        }
        .navigationTitle(LM.localizedString(for: "settings_title"))
        .toolbar {
          ToolbarItem(placement: .navigationBarTrailing) {
            Button {
              authViewModel.signOut()
              goalViewModel.clearGoals()
            } label: {
              Image(systemName: "rectangle.portrait.and.arrow.forward")
              .foregroundColor(.blue)
            }
          }
        }
        .sheet(isPresented: $showChangePasswordView) {
          AccountView(isChangingPassword: true)
          .environmentObject(authViewModel)
          .environmentObject(goalViewModel)
          .presentationDetents([.medium])
        }
        .sheet(isPresented: $showDeleteAccountView) {
          AccountView(isChangingPassword: false)
          .environmentObject(authViewModel)
          .environmentObject(goalViewModel)
          .presentationDetents([.medium])
        }
      }
    }

  // MARK: - Footer
  var copyrightFooter: some View {
    HStack {
      Spacer()
      Text(LM.localizedString(for: "copyright_footer"))
          .multilineTextAlignment(.center)
      Spacer()
    }
    .padding(.vertical, 8)
  }
}

#Preview {
  SettingsView()
    .environmentObject(AuthViewModel())
    .environmentObject(GoalViewModel())
    .environmentObject(LocalizationManager())
}
