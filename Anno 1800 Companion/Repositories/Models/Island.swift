//
//  Island.swift
//  Anno 1800 Companion
//
//  Created by Rodolphe Beck on 30/05/2025.
//

import Foundation
import SwiftData

extension DBModel {
    @Model final class Island: Identifiable, Hashable {
        var id: UUID
        
        var name: String = ""
        var regionRaw: Int = RegionEnum.oldWorld.id
        
        var region: RegionEnum {
            get { RegionEnum(rawValue: regionRaw) }
            set { regionRaw = newValue.id }
        }
        
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
        
        var populationValues: [String: Int] {
            return [
                "farmers": farmers,
                "workers": workers,
                "artisans": artisans,
                "engineers": engineers,
                "investors": investors,
                "jornaleros": jornaleros,
                "obreros": obreros,
                "explorers": explorers,
                "technicians": technicians,
                "sheperds": sheperds,
                "elders": elders
            ]
        }
        
        init(id: UUID = UUID(), name: String = "", region: RegionEnum = .oldWorld, farmers: Int = 0, workers: Int = 0, artisans: Int = 0, engineers: Int = 0, investors: Int = 0, jornaleros: Int = 0, obreros: Int = 0, explorers: Int = 0, technicians: Int = 0, sheperds: Int = 0, elders: Int = 0) {
            self.id = id
            self.name = name
            self.region = region
            self.farmers = farmers
            self.workers = workers
            self.artisans = artisans
            self.engineers = engineers
            self.investors = investors
            self.jornaleros = jornaleros
            self.obreros = obreros
            self.explorers = explorers
            self.technicians = technicians
            self.sheperds = sheperds
            self.elders = elders
        }
        
        var description: String {
            "\(name) - \(population)"
        }
    }
}

extension ApiModel {
    
    struct Island: Codable, Equatable {
        var name: String = ""
        var region: Int =  RegionEnum.oldWorld.id
        
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
        
        var populationValues: [String: Int] {
            return [
                "farmers": farmers,
                "workers": workers,
                "artisans": artisans,
                "engineers": engineers,
                "investors": investors,
                "jornaleros": jornaleros,
                "obreros": obreros,
                "explorers": explorers,
                "technicians": technicians,
                "sheperds": sheperds,
                "elders": elders
            ]
        }
        
        var population: Int {
            switch region {
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
    }
}
