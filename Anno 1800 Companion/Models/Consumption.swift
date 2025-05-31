//
//  PopulationNeed.swift
//  Anno 1800 Companion
//
//  Created by Rodolphe Beck on 30/05/2025.
//

import Foundation

struct Consumption: Codable {
    let farmers: PopulationClass
    let workers: PopulationClass
    let artisans: PopulationClass
    let engineers: PopulationClass
    let investors: PopulationClass
    let scholars: PopulationClass
    let jornaleros: PopulationClass
    let obreros: PopulationClass
    let explorers: PopulationClass
    let technicians: PopulationClass
    let shepherds: PopulationClass
    let elders: PopulationClass
}

struct PopulationClass: Codable {
    let basic: [String: DoubleOrEmpty]
    let luxury: [String: DoubleOrEmpty]
}

/// Gère les valeurs numériques ou vides
enum DoubleOrEmpty: Codable {
    case double(Double)
    case empty
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let doubleValue = try? container.decode(Double.self) {
            self = .double(doubleValue)
        } else if let stringValue = try? container.decode(String.self), stringValue.isEmpty {
            self = .empty
        } else {
            throw DecodingError.typeMismatch(
                DoubleOrEmpty.self,
                DecodingError.Context(
                    codingPath: decoder.codingPath,
                    debugDescription: "Expected Double or Empty String"
                )
            )
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .double(let value):
            try container.encode(value)
        case .empty:
            try container.encode("")
        }
    }
    
    var value: Double? {
        switch self {
        case .double(let val): return val
        case .empty: return nil
        }
    }
}
