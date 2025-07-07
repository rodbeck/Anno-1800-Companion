//
//  AppLanguageManager.swift
//  Anno 1800 Companion
//
//  Created by Rodolphe Beck on 07/07/2025.
//

import Foundation

@Observable
class AppLanguageManager {
    static let shared = AppLanguageManager()
    
    private let userDefaultsKey = "app_selected_language"
    
    private init() {}
    
    // Langue actuellement sélectionnée dans l'app
    var currentLanguage: String {
        get {
            return UserDefaults.standard.string(forKey: userDefaultsKey) ?? systemLanguage
        }
        set {
            UserDefaults.standard.set(newValue, forKey: userDefaultsKey)
            NotificationCenter.default.post(name: .languageChanged, object: nil)
        }
    }
    
    // Langue du système
    var systemLanguage: String {
        let preferredLanguage = Locale.preferredLanguages.first ?? "en"
        return String(preferredLanguage.prefix(2))
    }
    
    // Réinitialiser à la langue du système
    func resetToSystemLanguage() {
        UserDefaults.standard.removeObject(forKey: userDefaultsKey)
        NotificationCenter.default.post(name: .languageChanged, object: nil)
    }
    
    // Vérifier si une langue personnalisée est définie
    var isUsingCustomLanguage: Bool {
        return UserDefaults.standard.string(forKey: userDefaultsKey) != nil
    }
}
