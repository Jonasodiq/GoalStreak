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
    @State private var showLogoutConfirmation = false
    @State private var isSoundEnabled = SoundPlayer.isSoundEnabled

    @AppStorage("selectedAppearance") private var selectedAppearance: String = "system"
    @AppStorage("selectedLanguage") private var selectedLanguage = "sv"

    enum AppearanceOption: String, CaseIterable, Identifiable {
      case light, dark, system
      var id: String { self.rawValue }

      func localizedLabel(using manager: LocalizationManager) -> String {
        switch self {
          case .light:  return manager.LS(for: "light_mode")
          case .dark:   return manager.LS(for: "dark_mode")
          case .system: return manager.LS(for: "system_mode")
        }
      }
    }

  // MARK: - BODY
  var body: some View {
    NavigationStack {
      List {
        // MARK: - Account
        Section(header: Text(LM.LS(for: "account_section"))) {
            Button {
              SoundPlayer.play("pop")
              showChangePasswordView = true
            } label: {
                Label(
                  title: { Text(LM.LS(for: "change_password")) },
                  icon: { Image(systemName: "key.fill").foregroundColor(.blue) }
                )
            }

            Button(role: .destructive) {
              SoundPlayer.play("pop")
              showDeleteAccountView = true
            } label: {
                Label(
                  title: { Text(LM.LS(for: "delete_account")) },
                  icon: { Image(systemName: "trash.fill").foregroundColor(.red) }
                )
            }
        }

        // MARK: - Notices
        Section(header: Text(LM.LS(for: "notice_section"))) {
          Toggle(isOn: $notificationsEnabled) {
            Label(
              title: { Text(LM.LS(for: "notice_item")) },
              icon: { Image(systemName: "bell.badge.fill").foregroundColor(.orange) }
            )
          }
        }
        .onChange(of: notificationsEnabled) { oldValue, newValue in
            if SoundPlayer.isSoundEnabled {
                SoundPlayer.play("pop")
            }

            if newValue {
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
                    if let error = error {
                        print("Notification permission error: \(error.localizedDescription)")
                    } else {
                        DispatchQueue.main.async {
                            notificationsEnabled = granted
                        }
                    }
                }
            } else {
                // Hantera om användaren stänger av notiser – exempelvis ta bort schemalagda notiser
                UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            }
        }
        
        // MARK: - Sound setting
        Section(header: Text(LM.LS(for: "sound_section"))) {
          Toggle(isOn: $isSoundEnabled) {
            Label(
              title: { Text(LM.LS(for: "sound_item")) },
              icon: { Image(systemName: "speaker.wave.2.fill").foregroundColor(.blue) }
            )
          }
          .onChange(of: isSoundEnabled) { oldValue, newValue in
            SoundPlayer.isSoundEnabled = newValue
            SoundPlayer.play("pop")
          }
        }

        // MARK: - Language
        Section(
            header: HStack {
                Text(LM.LS(for: "language_section"))
            }
        ) {
            Picker(
              selection: $selectedLanguage,
              label:
                HStack {
                  Image(systemName: "globe")
                    .foregroundColor(.blue)
                  Text(LM.LS(for: "language_section"))
                }
            ) {
                Text(LM.LS(for: "swedish")).tag("sv")
                Text(LM.LS(for: "english")).tag("en")
            }
            .pickerStyle(.inline)
            .onChange(of: selectedLanguage) {
                SoundPlayer.play("pop")
            }
        }

        // MARK: - Appearance
        Section(
            header: HStack {
              Text(LM.LS(for: "appearance_section"))
            }
        ) {
            Picker(
              selection: $selectedAppearance,
              label:
                HStack {
                  Image(systemName: "paintpalette.fill")
                    .foregroundColor(.pink)
                  Text(LM.LS(for: "color_theme"))
                }
            ) {
              ForEach(AppearanceOption.allCases) { option in
                Text(option.localizedLabel(using: LM))
                  .tag(option.rawValue)
              }
            }
            .pickerStyle(.inline)
            .onChange(of: selectedAppearance) {
                SoundPlayer.play("pop")
            }
        }

        // MARK: - About
        Section(header: Text(LM.LS(for: "about_section")), footer: copyrightFooter) {
          InfoRowView(icon: "apps.iphone", tint: .indigo, label: LM.LS(for: "application"), value: "Goal Streak")
          InfoRowView(icon: "info.circle", tint: .mint, label: LM.LS(for: "compatibility"), value: "iOS, iPadOS")
          InfoRowView(icon: "swift", tint: .orange, label: LM.LS(for: "technology"), value: "Swift")
          InfoRowView(icon: "gear", tint: .purple, label: "Version", value: "1.0")
          InfoRowView(icon: "ellipsis.curlybraces", tint: .brown, label: LM.LS(for: "developer"), value: "Jonas Niyazson")
          InfoRowView(icon: "globe",tint: .blue,label: LM.LS(for: "website_label"),value: "My Portfolio",isLink: true,
              linkDestination: URL(string: "https://my-easy-portfolio.netlify.app/"))
          InfoRowView(icon: "person.text.rectangle",tint: .blue,label: "Linkedin",value: "Jonas Niyazson",isLink: true,
              linkDestination: URL(string: "https://www.linkedin.com/in/jonas-niyazson-4972b11b0/"))
        }
      } //: - List
      .navigationTitle(LM.LS(for: "settings_title"))
      .toolbar { // Log out
        ToolbarItem(placement: .navigationBarTrailing) {
          Button {
            SoundPlayer.play("pop")
            showLogoutConfirmation = true
          } label: {
            Image(systemName: "rectangle.portrait.and.arrow.forward")
              .foregroundColor(.blue)
          }
        }
      }
      .alert(LM.LS(for: "logout_title"), isPresented: $showLogoutConfirmation) {
        Button(LM.LS(for: "logout_confirm"), role: .destructive) {
          SoundPlayer.play("pop")
          authViewModel.signOut()
          goalViewModel.clearGoals()
        }
        Button(LM.LS(for: "cancel"), role: .cancel) { }
      } message: {
        Text(LM.LS(for: "logout_message"))
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
      Text(LM.LS(for: "copyright_footer"))
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

