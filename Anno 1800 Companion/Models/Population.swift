//
//  Population.swift
//  Anno 1800 Companion
//
//  Created by Rodolphe Beck on 30/05/2025.
//

import Foundation

struct Population: Codable {
    let entries: [String: PopulationEntry]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let decoded = try container.decode([String: PopulationEntry].self)
        self.entries = decoded
    }
}

struct PopulationEntry: Codable {
    let id: Int
    let name: String
    let img: String
    let icon: String
    let firstProductionChain: Int
    let residence: Int
}
