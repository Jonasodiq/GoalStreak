//
//  LocalizationManager.swift
//  GoalStreak
//
//  Created by Jonas Niyazson on 2025-05-04.
//

import SwiftUI
import Foundation

class localizationManager: ObservableObject {
    static var defaultLanguage: String {
        if let code = Locale.current.language.languageCode?.identifier {
            return code
        } else {
            print("Kunde inte hämta systemspråk, använder 'sv'")
            return "sv"
        }
    }

    @AppStorage("selectedLanguage") var selectedLanguage: String = defaultLanguage {
        didSet {
            objectWillChange.send() 
        }
      
    }

    func localizedString(for key: String) -> String {
        guard let path = Bundle.main.path(forResource: selectedLanguage, ofType: "lproj"),
              let bundle = Bundle(path: path) else {
            return NSLocalizedString(key, comment: "")
        }
        return NSLocalizedString(key, tableName: nil, bundle: bundle, comment: "")
    }
}



