//
//  Extensions.swift
//  Anno 1800 Companion
//
//  Created by Rodolphe Beck on 28/05/2025.
//

import SwiftUI
import Foundation

extension Bundle {
    func decodeLocalized<T: Decodable>(_ type: T.Type, from file: String, dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate, keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys) -> T {
        
        // Utiliser la langue configurée dans l'app
        let languageCode = AppLanguageManager.shared.currentLanguage
        
        return decode(type, from: file, dateDecodingStrategy: dateDecodingStrategy, keyDecodingStrategy: keyDecodingStrategy, localization: languageCode)
    }
    
    func decode<T: Decodable>(_ type: T.Type, from file: String, dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate, keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys) -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate \(file) in bundle.")
        }
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file) from bundle.")
        }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = dateDecodingStrategy
        decoder.keyDecodingStrategy = keyDecodingStrategy
        
        do {
            return try decoder.decode(T.self, from: data)
        } catch DecodingError.keyNotFound(let key, let context) {
            fatalError("Failed to decode \(file) from bundle due to missing key '\(key.stringValue)' not found – \(context.debugDescription)")
        } catch DecodingError.typeMismatch(_, let context) {
            fatalError("Failed to decode \(file) from bundle due to type mismatch – \(context.debugDescription)")
        } catch DecodingError.valueNotFound(let type, let context) {
            fatalError("Failed to decode \(file) from bundle due to missing \(type) value – \(context.debugDescription)")
        } catch DecodingError.dataCorrupted(_) {
            fatalError("Failed to decode \(file) from bundle because it appears to be invalid JSON")
        } catch {
            fatalError("Failed to decode \(file) from bundle: \(error.localizedDescription)")
        }
    }
    
    func decode<T: Decodable>(_ type: T.Type, from file: String, dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate, keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys, localization: String? = nil) -> T {
        
        // Utiliser le bundle localisé si une localisation est spécifiée
        let bundle = localization != nil ? Bundle.main.localizedBundle(for: localization!) : Bundle.main
        
        guard let url = bundle.url(forResource: file, withExtension: nil) else {
            // Fallback vers le bundle principal si le fichier n'est pas trouvé dans la localisation
            if let fallbackUrl = Bundle.main.url(forResource: file, withExtension: nil) {
                return decodeFromUrl(fallbackUrl, type: type, file: file, dateDecodingStrategy: dateDecodingStrategy, keyDecodingStrategy: keyDecodingStrategy)
            }
            fatalError("Failed to locate \(file) in bundle.")
        }
        
        return decodeFromUrl(url, type: type, file: file, dateDecodingStrategy: dateDecodingStrategy, keyDecodingStrategy: keyDecodingStrategy)
    }
    
    // Fonction helper pour éviter la duplication de code
    private func decodeFromUrl<T: Decodable>(_ url: URL, type: T.Type, file: String, dateDecodingStrategy: JSONDecoder.DateDecodingStrategy, keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy) -> T {
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file) from bundle.")
        }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = dateDecodingStrategy
        decoder.keyDecodingStrategy = keyDecodingStrategy
        
        do {
            return try decoder.decode(T.self, from: data)
        } catch DecodingError.keyNotFound(let key, let context) {
            fatalError("Failed to decode \(file) from bundle due to missing key '\(key.stringValue)' not found – \(context.debugDescription)")
        } catch DecodingError.typeMismatch(_, let context) {
            fatalError("Failed to decode \(file) from bundle due to type mismatch – \(context.debugDescription)")
        } catch DecodingError.valueNotFound(let type, let context) {
            fatalError("Failed to decode \(file) from bundle due to missing \(type) value – \(context.debugDescription)")
        } catch DecodingError.dataCorrupted(_) {
            fatalError("Failed to decode \(file) from bundle because it appears to be invalid JSON")
        } catch {
            fatalError("Failed to decode \(file) from bundle: \(error.localizedDescription)")
        }
    }
    
    // Extension pour obtenir un bundle localisé
    private func localizedBundle(for localization: String) -> Bundle {
        guard let path = Bundle.main.path(forResource: localization, ofType: "lproj"),
              let bundle = Bundle(path: path) else {
            return Bundle.main
        }
        return bundle
    }
}

extension View {
    func onLanguageChange(_ action: @escaping () -> Void) -> some View {
        onReceive(NotificationCenter.default.publisher(for: .languageChanged)) { _ in
            action()
        }
    }
}

extension String {
    func localized() -> String {
        return AppLanguageManager.shared.localizedString(for: self)
    }
    
    // Version avec paramètres pour String.localizedStringWithFormat
    func localized(with arguments: CVarArg...) -> String {
        let localizedString = AppLanguageManager.shared.localizedString(for: self)
        return String(format: localizedString, arguments: arguments)
    }
}

// MARK: - Macro globale pour simplifier l'utilisation
func L(_ key: String) -> String {
    return AppLanguageManager.shared.localizedString(for: key)
}

// Version avec paramètres
func L(_ key: String, _ arguments: CVarArg...) -> String {
    let localizedString = AppLanguageManager.shared.localizedString(for: key)
    return String(format: localizedString, arguments: arguments)
}
