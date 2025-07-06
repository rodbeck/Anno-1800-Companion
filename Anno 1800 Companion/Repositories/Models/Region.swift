//
//  Locations.swift
//  Anno 1800 Companion
//
//  Created by Rodolphe Beck on 27/05/2025.
//

import Foundation

enum RegionEnum: CaseIterable, Identifiable, CustomStringConvertible {
    case oldWorld
    case newWorld
    case capeTrelawney
    case theArctic
    case enbesa
    
    init(rawValue: Int) {
        switch rawValue {
        case 1: self = .oldWorld
        case 2: self = .newWorld
        case 3: self = .capeTrelawney
        case 4: self = .theArctic
        case 5: self = .enbesa
        default: self = .oldWorld
        }
    }
    
    var description: String {
        switch self {
        case .oldWorld:
            return "The Old World"
        case .newWorld:
            return "The New World"
        case .capeTrelawney:
            return "Cape Trelawney"
        case .theArctic:
            return "The Arctic"
        case .enbesa:
            return "Enbesa"
        }
    }
    
    var populationIDs: [Int] {
        switch self {
        case .oldWorld:
            return [1,2,3,4,5,8]
        case .newWorld:
            return [6,7]
        case .capeTrelawney:
            return [1,2,3,4,5,8]
        case .theArctic:
            return [9,10]
        case .enbesa:
            return [11,12]
        }
    }
    
    var id: Int {
        switch self {
        case .oldWorld:
            return 1
        case .newWorld:
            return 2
        case .capeTrelawney:
            return 3
        case .theArctic:
            return 4
        case .enbesa:
            return 5
        }
    }
    
    var img: String {
        switch self {
        case .oldWorld:
            return "regions/the-old-world"
        case .newWorld:
            return "regions/the-new-world"
        case .capeTrelawney:
            return "regions/cape-trelawney"
        case .theArctic:
            return "regions/the-arctic"
        case .enbesa:
            return "regions/enbesa"
        }
    }
}
