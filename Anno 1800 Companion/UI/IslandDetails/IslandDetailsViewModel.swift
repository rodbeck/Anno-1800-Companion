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
        var calculatedNeeds: [ProductionNeed]
        var residenceCount: [String: Int]
        
        
        init(island: Island = Island()) {
            self.island = island
            self.need = Bundle.main.decode(Consumption.self, from: "consumption.json")
            self.population = Bundle.main.decode(Population.self, from: "population.json")
            self.producers = Bundle.main.decode(Producers.self, from: "producers.json")
            self.regions = Bundle.main.decode(Regions.self, from: "regions.json")
            self.calculatedNeeds = []
            self.residenceCount = [:]
        }
        
        func calculateProductionNeeds() -> [ProductionNeed] {
            var results: [ProductionNeed] = []

            for (populationKey, populationEntry) in population.entries {
                // 1) Nombre de maisons pour cette population sur ton île
                let populationCount = (self.island.populationValues[populationKey] ?? 0)
                if populationCount == 0 { continue }
                //guard let populationCount = island.value(forKey: populationKey) as? Int else { continue }
                let residences = populationCount / populationEntry.residence

                // 2) Besoins : basic + luxury
                let needsGroups = [
                    need.entries[populationKey]?.basic,
                    need.entries[populationKey]?.luxury
                ]
                
                for needs in needsGroups.compactMap({ $0 }) {
                    for (needName, entry) in needs where entry.value != nil {
                        let consumptionPerResident = entry.value!
                        let totalConsumption = Double(residences) * consumptionPerResident

                        // Trouver le bâtiment qui produit ce bien
                        guard let producerEntry = producers.entries.first(where: { $0.value.product == needName }) else {
                            continue // Pas de producteur trouvé pour ce bien
                        }

                        let productionPerMin = 60.0 / Double(producerEntry.value.productionTime)
                        let buildingsNeededExact = totalConsumption / productionPerMin
                        let buildingsNeeded = Int(ceil(totalConsumption / productionPerMin))
                        let usage = buildingsNeededExact / Double(buildingsNeeded)

                        let productionNeed = ProductionNeed(
                            populationType: populationKey,
                            goodName: needName,
                            producerName: producerEntry.value.building,
                            residences: residences,
                            consumptionPerResident: consumptionPerResident,
                            totalConsumptionPerMin: totalConsumption,
                            productionPerMin: productionPerMin,
                            buildingsNeeded: buildingsNeeded,
                            usagePercentage: usage
                        )

                        results.append(productionNeed)
                    }
                }
            }

            return results
        }
        
        func calculate() {
            calculatedNeeds = calculateProductionNeeds()
        }
    }
    
    static var oldWorldExample: ViewModel {
        ViewModel(island: .oldWorldExample)
    }
    
    static var newWorldExample: ViewModel {
        ViewModel(island: .newWorldExample)
    }
}

struct ConsumptionEntry: Codable {
    let value: Double?
}
