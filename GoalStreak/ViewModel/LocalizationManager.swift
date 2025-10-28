//
//  LocalizationManager.swift
//  GoalStreak
//
//  Created by Jonas Niyazson on 2025-05-04.
//

import SwiftUI
import Foundation

class LocalizationManager: ObservableObject {
  
    // Returns the system language by default / Systemets standardspråk
    static var defaultLanguage: String {
        if let code = Locale.current.language.languageCode?.identifier {
            return code
        } else {
            print("Kunde inte hämta systemspråk, använder 'sv'")
            return "sv" // Fallback-standard
        }
    }

   // Saves the user's selected language with AppStorage / Användarens valda språk (sparas med AppStorage)
    @AppStorage("selectedLanguage") var selectedLanguage: String = defaultLanguage {
        didSet {objectWillChange.send()}
    }

    // Retrieves a localized string for the specified key based on the selected language
    // Hämtar översatt sträng för en given nyckel
    func LS(for key: String) -> String {
        if let path = Bundle.main.path(forResource: selectedLanguage, ofType: "lproj"),
           let bundle = Bundle(path: path) {
            return NSLocalizedString(key, tableName: nil, bundle: bundle, comment: "")
        } else {
            // Logga och använd fallback
            print("⚠️ Saknar språkfil för språket: '\(selectedLanguage)'. Försöker använda 'Base'.")
            
            // Försök använda "Base.lproj"
            if let basePath = Bundle.main.path(forResource: "Base", ofType: "lproj"),
               let baseBundle = Bundle(path: basePath) {
                return NSLocalizedString(key, tableName: nil, bundle: baseBundle, comment: "")
            }

            // Sista fallback: systemets standard
            print("⚠️ Saknar även 'Base.lproj'. Använder systemets språk som sista utväg.")
            return NSLocalizedString(key, comment: "")
        }
    }
} 
