//
//  Regions.swift
//  Anno 1800 Companion
//
//  Created by Rodolphe Beck on 31/05/2025.
//

import Foundation

struct Regions: Codable {
    let entries: [String: RegionEntry]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let decoded = try container.decode([String: RegionEntry].self)
        self.entries = decoded
    }
}

struct RegionEntry: Codable, Hashable {
    let id: Int
    let name: String
    let img: String
    let dlcID: Int
    let populationIDs: [Int]
    
    static var oldWorld: RegionEntry {
        .init(id: 1, name: "The Old World", img: "regions/the-old-world", dlcID: 0, populationIDs: [1,2,3,4,5,8])
    }
    
    static var newWorld: RegionEntry {
        .init(id: 2, name: "The New World", img: "regions/the-new-world", dlcID: 0, populationIDs: [6,7])
    }
    
    static var capeTrelawney: RegionEntry {
        .init(id: 3, name: "Cape Trelawney", img: "regions/cape-trelawney", dlcID: 2, populationIDs: [1, 2, 3, 4, 5, 8])
    }
    
    static var theArctic: RegionEntry {
        .init(id: 4, name: "The Arctic", img: "regions/the-arctic", dlcID: 4, populationIDs: [9,10])
    }
    
    static var enbesa: RegionEntry {
        .init(id: 5, name: "Enbesa", img: "regions/enbesa", dlcID: 9, populationIDs: [11,12])
    }
}
