//
//  LocalizationManager.swift
//  Anno 1800 Companion
//
//  Created by Rodolphe Beck on 07/07/2025.
//

import Foundation
import Combine

class LocalizationManager: ObservableObject {
    static let shared = LocalizationManager()
    
    @Published var currentLanguage: String
    @Published var appContent: AppContent?
    
    private let cache = LocalizationCache()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        // Détermine la langue actuelle
        //self.currentLanguage = Locale.current.languageCode ?? "en"
        self.currentLanguage = Locale.current.language.languageCode?.identifier ?? "en"
        
        // Écoute les changements de langue système
        setupLanguageObserver()
        
        // Charge le contenu initial
        loadContent()
    }
    
    // MARK: - Chargement du contenu JSON
    func loadContent() {
        // Vérifie le cache d'abord
        if let cachedContent = cache.getCachedContent(for: currentLanguage) {
            self.appContent = cachedContent
            return
        }
        
        // Charge depuis les fichiers
        guard let content = loadJSONContent() else {
            // Fallback vers l'anglais si la langue actuelle n'est pas disponible
            if currentLanguage != "en" {
                currentLanguage = "en"
                loadContent()
            }
            return
        }
        
        // Met en cache et publie
        cache.setCachedContent(content, for: currentLanguage)
        self.appContent = content
    }
    
    func loadContent(named: String) {
        // Vérifie le cache d'abord
        if let cachedContent = cache.getCachedContent(for: currentLanguage) {
            self.appContent = cachedContent
            return
        }
        
        // Charge depuis les fichiers
        guard let content = loadJSONContent(named: named) else {
            // Fallback vers l'anglais si la langue actuelle n'est pas disponible
            if currentLanguage != "en" {
                currentLanguage = "en"
                loadContent()
            }
            return
        }
        
        // Met en cache et publie
        cache.setCachedContent(content, for: currentLanguage)
        self.appContent = content
    }
    
    private func loadJSONContent(named: String) -> AppContent? {
        // Cherche le fichier dans le bon dossier .lproj
        guard let path = Bundle.main.path(
            forResource: named,
            ofType: "json",
            inDirectory: "\(currentLanguage).lproj"
        ) else {
            print("⚠️ Fichier content.json non trouvé pour la langue: \(currentLanguage)")
            return nil
        }
        
        guard let data = NSData(contentsOfFile: path) as Data? else {
            print("⚠️ Impossible de lire le fichier: \(path)")
            return nil
        }
        
        do {
            let content = try JSONDecoder().decode(AppContent.self, from: data)
            print("✅ Contenu chargé pour la langue: \(currentLanguage)")
            return content
        } catch {
            print("❌ Erreur de décodage JSON: \(error)")
            return nil
        }
    }
    
    private func loadJSONContent() -> AppContent? {
        // Cherche le fichier dans le bon dossier .lproj
        guard let path = Bundle.main.path(
            forResource: "content",
            ofType: "json",
            inDirectory: "\(currentLanguage).lproj"
        ) else {
            print("⚠️ Fichier content.json non trouvé pour la langue: \(currentLanguage)")
            return nil
        }
        
        guard let data = NSData(contentsOfFile: path) as Data? else {
            print("⚠️ Impossible de lire le fichier: \(path)")
            return nil
        }
        
        do {
            let content = try JSONDecoder().decode(AppContent.self, from: data)
            print("✅ Contenu chargé pour la langue: \(currentLanguage)")
            return content
        } catch {
            print("❌ Erreur de décodage JSON: \(error)")
            return nil
        }
    }
    
    // MARK: - Changement de langue
    func switchLanguage(_ languageCode: String) {
        guard languageCode != currentLanguage else { return }
        
        currentLanguage = languageCode
        loadContent()
        
        // Notifie les autres composants
        NotificationCenter.default.post(
            name: .languageChanged,
            object: languageCode
        )
    }
    
    // MARK: - Observateur des changements système
    private func setupLanguageObserver() {
        NotificationCenter.default.publisher(
            for: NSLocale.currentLocaleDidChangeNotification
        )
        .sink { [weak self] _ in
            let newLanguage = Locale.current.languageCode ?? "en"
            self?.switchLanguage(newLanguage)
        }
        .store(in: &cancellables)
    }
    
    // MARK: - Méthodes utilitaires
    func availableLanguages() -> [String] {
        return Bundle.main.localizations.filter { $0 != "Base" }
    }
    
    func localizedString(_ key: String) -> String {
        return NSLocalizedString(key, comment: "")
    }
    
    func reloadContent() {
        cache.clearCache()
        loadContent()
    }
}

// MARK: - Extensions
extension Notification.Name {
    static let languageChanged = Notification.Name("languageChanged")
}

extension LocalizationManager {
    // Méthodes de convenance pour accéder aux données
    var categories: [AppContent.Category] {
        return appContent?.categories ?? []
    }
    
    var messages: AppContent.Messages? {
        return appContent?.messages
    }
    
    var onboarding: AppContent.Onboarding? {
        return appContent?.onboarding
    }
}
