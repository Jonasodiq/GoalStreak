//
//  LocalizationManager.swift
//  GoalStreak
//
//  Created by Jonas Niyazson on 2025-05-04.
//

import SwiftUI
import Foundation

class LocalizationManager: ObservableObject {
  
    // Returns the system language by default
    static var defaultLanguage: String {
        if let code = Locale.current.language.languageCode?.identifier {
            return code
        } else {
            print("Kunde inte hämta systemspråk, använder 'sv'")
            return "sv"
        }
    }

   // Saves the user's selected language with AppStorage
    @AppStorage("selectedLanguage") var selectedLanguage: String = defaultLanguage {
        didSet {objectWillChange.send()}
    }

    // Retrieves a localized string for the specified key based on the selected language
    func localizedString(for key: String) -> String {
        guard let path = Bundle.main.path(forResource: selectedLanguage, ofType: "lproj"),
              let bundle = Bundle(path: path) else {
            return NSLocalizedString(key, comment: "")
        }
        return NSLocalizedString(key, tableName: nil, bundle: bundle, comment: "")
    }
}
