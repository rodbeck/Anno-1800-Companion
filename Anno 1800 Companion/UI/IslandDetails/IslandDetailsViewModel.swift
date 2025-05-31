//
//  Island.swift
//  Anno 1800 Companion
//
//  Created by Rodolphe Beck on 27/05/2025.
//

import Foundation

// MARK: - Routing

extension IslandDetailsView {
    struct Routing: Equatable {
        var detailsSheet: Bool = false
    }
}

// MARK: - ViewModel

extension IslandDetailsView {
    @Observable
    class ViewModel {
        var island: Island
        var need: Consumption
        var population: Population
        var producers: Producers
        var regions: Regions
        var calculatedNeeds: [Need]
        
        init(island: Island = Island()) {
            self.island = island
            self.need = Bundle.main.decode(Consumption.self, from: "consumption.json")
            self.population = Bundle.main.decode(Population.self, from: "population.json")
            self.producers = Bundle.main.decode(Producers.self, from: "producers.json")
            self.regions = Bundle.main.decode(Regions.self, from: "regions.json")
            self.calculatedNeeds = []
        }
        
        func calculate() {
            for region in regions.entries {
                
            }
            
            switch island.region.id {
            case 0:
                print("calculate")
                
//                let farmerResidenceCount = island.farmers / population.farmers.residence
//                
//                let fish = Fish(value: Double((need.farmers.basic["Fish"]?.value ?? 0)) * Double(farmerResidenceCount))
//                let workClothes = WorkClothes(value: Double(need.farmers.basic["Work Clothes"]?.value ?? 0) * Double(farmerResidenceCount))
//                let shnaps = Shnaps(value: Double(need.farmers.basic["Shnaps"]?.value ?? 0) * Double(farmerResidenceCount))
//                calculatedNeeds.append(fish)
//                calculatedNeeds.append(workClothes)
//                calculatedNeeds.append(shnaps)
            default:
                print("Default")
            }
        }
    }
    
    static var oldWorldExample: ViewModel {
        ViewModel(island: .oldWorldExample)
    }
    
    static var newWorldExample: ViewModel {
        ViewModel(island: .newWorldExample)
    }
}


