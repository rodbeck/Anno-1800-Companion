//
//  LocalizationCache.swift
//  Anno 1800 Companion
//
//  Created by Rodolphe Beck on 07/07/2025.
//

import Foundation

class LocalizationCache {
    private var cache: [String: AppContent] = [:]
    
    func getCachedContent(for language: String) -> AppContent? {
        return cache[language]
    }
    
    func setCachedContent(_ content: AppContent, for language: String) {
        cache[language] = content
    }
    
    func clearCache() {
        cache.removeAll()
    }
}
