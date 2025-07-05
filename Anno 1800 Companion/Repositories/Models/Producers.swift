//
//  Producers.swift
//  Anno 1800 Companion
//
//  Created by Rodolphe Beck on 31/05/2025.
//

import Foundation

struct Producers: Codable {
    let entries: [String: ProducerEntry]

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let decoded = try container.decode([String: ProducerEntry].self)
        self.entries = decoded
    }
}

struct ProducerEntry: Codable {
    let product: String
    let building: String
    let img: String
    let regionID: Int
    let productionTime: Int
    let construction: [String: Int]
    let maintenance: [String: Int]
}

