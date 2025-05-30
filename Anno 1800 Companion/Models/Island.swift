//
//  Island.swift
//  Anno 1800 Companion
//
//  Created by Rodolphe Beck on 30/05/2025.
//

import Foundation

struct Island: Identifiable {
    var id: UUID = UUID()
    
    var name: String
    var region: RegionEnum
    
    // The Old World
    var farmers: Int = 0
    var workers: Int = 0
    var artisans: Int = 0
    var engineers: Int = 0
    var investors: Int = 0
    
    // The New World
    var jornaleros: Int = 0
    var obreros: Int = 0
    
    // The Arctic
    var explorers: Int = 0
    var technicians: Int = 0
    
    // Enbesa
    var sheperds: Int = 0
    var elders: Int = 0
    
    var population: Int {
        switch region {
        case .oldWorld:
            return farmers + workers + artisans + engineers + investors
        case .newWorld:
            return jornaleros + obreros
        case .theArctic:
            return explorers + technicians
        case .enbesa:
            return sheperds + elders
        }
    }
    
    var description: String {
        "\(name) - \(population)"
    }
    
    static var oldWorldExample: Island {
        .init(name: "Old World Island", region: .oldWorld, farmers: 100, workers: 200, artisans: 300, engineers: 400, investors: 500)
    }
    
    static var newWorldExample: Island {
        .init(name: "New World island", region: .newWorld, jornaleros: 100, obreros: 200)
    }
    
    static var theArcticExample: Island {
        .init(name: "The Arctic island", region: .theArctic, explorers: 100, technicians: 200)
    }
    
    static var enbesaExample: Island {
        .init(name: "Enbesa Island", region: .enbesa, sheperds: 100, elders: 200)
    }
}
