//
//  Anno_1800_CompanionTests.swift
//  Anno 1800 CompanionTests
//
//  Created by Rodolphe Beck on 24/05/2025.
//

import Testing
@testable import Anno_1800_Companion

struct Anno_1800_CompanionTests {
    
    @MainActor
    @Test func calculateOldWorldConsumption() {
        let oldWorldVM = IslandDetailsView.ViewModel(island: .oldWorldExample)
        let oldWorldResults = oldWorldVM.calculateProductionNeeds()
        #expect(oldWorldResults.count > 0)
        
        print("*** \(DBModel.Island.oldWorldExample.name) ***")
        for result in oldWorldResults {
            print("Results for \(result.producerName): \(result.buildingsNeeded)")
        }
    }
    
    @MainActor
    @Test func calculateNewWorldConsumption() {
        let newWorldVM = IslandDetailsView.ViewModel(island: .newWorldExample)
        let newWorldResults = newWorldVM.calculateProductionNeeds()
        #expect(newWorldResults.count > 0)
        
        print("*** \(DBModel.Island.newWorldExample.name) ***")
        for result in newWorldResults {
            print("Results for \(result.producerName): \(result.buildingsNeeded)")
        }
    }
    
    @MainActor
    @Test func calculateEnbesaConsumption() {
        let enbesaVM = IslandDetailsView.ViewModel(island: .enbesaExample)
        let enbesaResults = enbesaVM.calculateProductionNeeds()
        #expect(enbesaResults.count > 0)
        
        print("*** \(DBModel.Island.enbesaExample.name) ***")
        for result in enbesaResults {
            print("Results for \(result.producerName): \(result.buildingsNeeded)")
        }
    }
    
    @MainActor
    @Test func calculateTheArcticsConsumption() {
        let theArcticsVM = IslandDetailsView.ViewModel(island: .theArcticExample)
        let theArcticsResults = theArcticsVM.calculateProductionNeeds()
        #expect(theArcticsResults.count > 0)
        
        print("*** \(DBModel.Island.theArcticExample.name) ***")
        for result in theArcticsResults {
            print("Results for \(result.producerName): \(result.buildingsNeeded)")
        }
    }
    
    @MainActor
    @Test func importPopulationNeeds() {
        let oldWorldVM = IslandDetailsView.ViewModel(island: .oldWorldExample)
        let population = oldWorldVM.population
        let need = oldWorldVM.need
        
        #expect(need.farmers.basic.count > 0)
        #expect(need.farmers.luxury.count > 0)
        #expect(need.elders.luxury.count > 0)
        #expect(population.entries.count > 0)
    }

    @MainActor
    @Test func loadLanguageFiles() {
        let oldWorldVM = IslandDetailsView.ViewModel(island: .oldWorldExample)
        
        let regions = oldWorldVM.regions
        
        for region in regions.entries {
            print("\(region.key): \(region.value)")
        }
        
        #expect(regions.entries.count > 0)
    }
}
