//
//  Anno_1800_CompanionTests.swift
//  Anno 1800 CompanionTests
//
//  Created by Rodolphe Beck on 24/05/2025.
//

import Testing
@testable import Anno_1800_Companion

struct Anno_1800_CompanionTests {
    
    @Test func calculateConsumption() async throws {
        let vm = IslandDetailsView.ViewModel(island: .oldWorldExample)
        let results = vm.calculateProductionNeeds()
        
        #expect(results.count > 0)
        
        for result in results {
            print(result.populationType)
            print(result.goodName)
            print(result.buildingsNeeded)
            print("\(result.usagePercentage*100)%")
        }
        
        
    }
    
    @Test func importPopulationNeeds() async throws {
        let vm = IslandDetailsView.ViewModel(island: .oldWorldExample)
        let population = vm.population
        let need = vm.need
        
        for p in population.entries {
            print("Population: \(p.value.name) = \(p.value.id)")
        }
        
        vm.calculate()
        
        #expect(need.farmers.basic.count > 0)
        #expect(need.farmers.luxury.count > 0)
        
    }

}
