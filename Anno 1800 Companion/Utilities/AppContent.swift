//
//  AppContent.swift
//  Anno 1800 Companion
//
//  Created by Rodolphe Beck on 07/07/2025.
//

import Foundation
import Combine

// MARK: - Models pour le JSON
struct AppContent: Codable {
    let categories: [Category]
    let messages: Messages
    let onboarding: Onboarding
    
    struct Category: Codable, Identifiable {
        let id: String
        let name: String
        let description: String
        let icon: String
    }
    
    struct Messages: Codable {
        let loading: String
        let error: String
        let noData: String
        let refresh: String
        
        enum CodingKeys: String, CodingKey {
            case loading, error
            case noData = "no_data"
            case refresh
        }
    }
    
    struct Onboarding: Codable {
        let step1: Step
        let step2: Step
        
        struct Step: Codable {
            let title: String
            let subtitle: String
        }
    }
}
