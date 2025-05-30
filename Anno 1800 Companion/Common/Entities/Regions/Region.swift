//
//  Locations.swift
//  Anno 1800 Companion
//
//  Created by Rodolphe Beck on 27/05/2025.
//

import Foundation

protocol Region {
    var name: String { get set }
    var image: String { get set }
    var id: Int { get set }
    var dlcId: Int { get set }
    var populationId: [Int] { get set }
}

enum RegionEnum: CaseIterable, Identifiable, CustomStringConvertible {
    var id: Self { self }
    
    case oldWorld
    case newWorld
    case theArctic
    case enbesa
    
    var description: String {
        switch self {
        case .oldWorld:
            return "The Old World"
        case .newWorld:
            return "The New World"
        case .theArctic:
            return "The Arctic"
        case .enbesa:
            return "Enbesa"
        }
    }
    
    var image: String {
        switch self {
        case .oldWorld:
            return "regions/the-old-world"
        case .newWorld:
            return "regions/the-new-world"
        case .theArctic:
            return "regions/the-arctic"
        case .enbesa:
            return "regions/enbesa"
        }
    }
}
