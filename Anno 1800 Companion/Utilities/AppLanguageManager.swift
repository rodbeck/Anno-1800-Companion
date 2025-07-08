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
    private(set) var currentBundle: Bundle = Bundle.main
    
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
    
    private func updateBundle() {
        if isUsingCustomLanguage {
            // Pour xcstrings, on utilise le bundle avec la langue spécifiée
            if let path = Bundle.main.path(forResource: currentLanguage, ofType: "lproj"),
               let bundle = Bundle(path: path) {
                currentBundle = bundle
            } else {
                // Fallback: créer un bundle temporaire pour la langue
                currentBundle = Bundle.main
            }
        } else {
            currentBundle = Bundle.main
        }
    }
    
    // Méthode pour obtenir une chaîne localisée avec xcstrings
    func localizedString(for key: String) -> String {
        if !isUsingCustomLanguage {
            return NSLocalizedString(key, comment: "")
        }
        
        // Pour xcstrings, on peut utiliser cette approche
        if let path = Bundle.main.path(forResource: currentLanguage, ofType: "lproj"),
           let bundle = Bundle(path: path) {
            return NSLocalizedString(key, bundle: bundle, comment: "")
        }
        
        // Fallback vers la localisation par défaut
        return NSLocalizedString(key, comment: "")
    }
}
