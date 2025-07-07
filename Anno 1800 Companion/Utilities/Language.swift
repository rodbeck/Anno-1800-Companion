//
//  Language.swift
//  Anno 1800 Companion
//
//  Created by Rodolphe Beck on 07/07/2025.
//

import Foundation
struct Language: Identifiable, Equatable {
    let id: String
    let name: String
    let nativeName: String
    
    static let availableLanguages = [
        Language(id: "en", name: "English", nativeName: "English"),
        Language(id: "fr", name: "French", nativeName: "Français")
        // Ajoutez d'autres langues selon vos besoins
    ]
}
