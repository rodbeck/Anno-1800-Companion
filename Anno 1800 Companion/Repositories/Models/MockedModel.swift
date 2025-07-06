//
//  MockedModel.swift
//  Anno 1800 Companion
//
//  Created by Rodolphe Beck on 06/07/2025.
//

import Foundation

@MainActor
extension DBModel.Island {
    static let mockedData: [DBModel.Island] = [
        DBModel.Island(name: "Old World Island", region: .oldWorld, farmers: 1200, workers: 800, artisans: 500, engineers: 0, investors: 0),
        DBModel.Island(name: "New World island", region: .newWorld, jornaleros: 100, obreros: 200),
        DBModel.Island(name: "Cape Treylawney Island", region: .capeTrelawney, farmers: 2400, workers: 1800, artisans: 700, engineers: 0, investors: 0),
        DBModel.Island(name: "The Arctic island", region: .theArctic, explorers: 100, technicians: 200),
        DBModel.Island(name: "Enbesa Island", region: .enbesa, sheperds: 100, elders: 200)
    ]
    
    static var oldWorldExample: DBModel.Island {
        .init(name: "Old World Island", region: .oldWorld, farmers: 1200, workers: 800, artisans: 500, engineers: 0, investors: 0)
    }
    
    static var newWorldExample: DBModel.Island {
        .init(name: "New World island", region: .newWorld, jornaleros: 100, obreros: 200)
    }
    
    static var theArcticExample: DBModel.Island {
        .init(name: "The Arctic island", region: .theArctic, explorers: 500, technicians: 200)
    }
    
    static var enbesaExample: DBModel.Island {
        .init(name: "Enbesa Island", region: .enbesa, sheperds: 100, elders: 200)
    }
}
