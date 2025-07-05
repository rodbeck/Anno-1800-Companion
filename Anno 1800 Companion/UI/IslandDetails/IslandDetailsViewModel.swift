//
//  Island.swift
//  Anno 1800 Companion
//
//  Created by Rodolphe Beck on 27/05/2025.
//

import Combine
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
        var island: Island {
            didSet {
                calculate()
            }
        }
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
            var resultsDict: [String: ProductionNeed] = [:]
            for (populationKey, populationEntry) in population.entries {
                let populationCount = (self.island.populationValues[populationKey] ?? 0)
                if populationCount == 0 { continue }
                let residences = populationCount / populationEntry.residence
                
                let needsGroups = [
                    need.entries[populationKey]?.basic,
                    need.entries[populationKey]?.luxury
                ]
                
                for needs in needsGroups.compactMap({ $0 }) {
                    for (needName, entry) in needs where entry.value != nil {
                        guard let producerEntry = producers.entries.first(where: { $0.value.product == needName }) else { continue }
                        let consumptionPerResident = entry.value!
                        let totalConsumption = Double(residences) * consumptionPerResident
                        let productionPerMin = producerEntry.value.productionTime > 0 ? (60.0 / Double(producerEntry.value.productionTime)) : 0.0
                        if productionPerMin == 0 { continue }
                        let buildingsNeededExact = totalConsumption / productionPerMin
                        if buildingsNeededExact.isNaN || buildingsNeededExact.isInfinite { continue }
                        
                        if var existing = resultsDict[needName] {
                            // Sum totals
                            existing.totalConsumptionPerMin += totalConsumption
                            existing.buildingsNeeded = max(1, Int(ceil(existing.totalConsumptionPerMin / productionPerMin)))
                            existing.usagePercentage = existing.buildingsNeeded > 0 ? (existing.totalConsumptionPerMin / productionPerMin) / Double(existing.buildingsNeeded) : 0.0
                            resultsDict[needName] = existing
                        } else {
                            let buildingsNeeded = max(1, Int(ceil(buildingsNeededExact)))
                            let usage = buildingsNeeded > 0 ? (buildingsNeededExact / Double(buildingsNeeded)) : 0.0
                            let productionNeed = ProductionNeed(
                                populationType: "Combined",
                                goodName: needName,
                                producerName: producerEntry.value.building,
                                residences: residences,
                                consumptionPerResident: consumptionPerResident,
                                totalConsumptionPerMin: totalConsumption,
                                productionPerMin: productionPerMin,
                                buildingsNeeded: buildingsNeeded,
                                usagePercentage: usage,
                                img: producerEntry.value.img
                            )
                            resultsDict[needName] = productionNeed
                        }
                    }
                }
            }
            return Array(resultsDict.values).sorted(by: { $0.populationType < $1.populationType })
            }
        
//        func calculateProductionNeeds() -> [ProductionNeed] {
//            var results: [ProductionNeed] = []
//            var seenKeys: Set<String> = []
//
//            for (populationKey, populationEntry) in population.entries {
//                let populationCount = (self.island.populationValues[populationKey] ?? 0)
//                if populationCount == 0 { continue }
//                let residences = populationCount / populationEntry.residence
//
//                let needsGroups = [
//                    need.entries[populationKey]?.basic,
//                    need.entries[populationKey]?.luxury
//                ]
//
//                for needs in needsGroups.compactMap({ $0 }) {
//                    for (needName, entry) in needs where entry.value != nil {
//                        let uniqueKey = "\(populationKey)_\(needName)"
//                        if seenKeys.contains(uniqueKey) { continue }
//                        seenKeys.insert(uniqueKey)
//                        print("✅ New key: \(uniqueKey)")
//
//                        let consumptionPerResident = entry.value!
//                        let totalConsumption = Double(residences) * consumptionPerResident
//
//                        guard let producerEntry = producers.entries.first(where: { $0.value.product == needName }) else {
//                            continue
//                        }
//
//                        let productionPerMin = 60.0 / Double(producerEntry.value.productionTime)
//                        let buildingsNeededExact = totalConsumption / productionPerMin
//                        let buildingsNeeded = Int(ceil(buildingsNeededExact))
//                        let usage = buildingsNeededExact / Double(buildingsNeeded)
//
//                        let productionNeed = ProductionNeed(
//                            populationType: populationKey,
//                            goodName: needName,
//                            producerName: producerEntry.value.building,
//                            residences: residences,
//                            consumptionPerResident: consumptionPerResident,
//                            totalConsumptionPerMin: totalConsumption,
//                            productionPerMin: productionPerMin,
//                            buildingsNeeded: buildingsNeeded,
//                            usagePercentage: usage
//                        )
//
//                        results.append(productionNeed)
//                    }
//                }
//            }
//
//            return results
//        }
        
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
