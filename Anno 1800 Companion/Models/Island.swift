//
//  Island.swift
//  Anno 1800 Companion
//
//  Created by Rodolphe Beck on 30/05/2025.
//

import Foundation

struct Island: Identifiable {
    var id: UUID = UUID()
    
    var name: String = ""
    var region: RegionEntry = .oldWorld
    
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
        switch region.id {
        case 1:
            return farmers + workers + artisans + engineers + investors
        case 2:
            return jornaleros + obreros
        case 3:
            return farmers + workers + artisans + engineers + investors
        case 4:
            return explorers + technicians
        case 5:
            return sheperds + elders
        default:
            return 0
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
