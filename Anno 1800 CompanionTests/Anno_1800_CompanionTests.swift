//
//  Anno_1800_CompanionTests.swift
//  Anno 1800 CompanionTests
//
//  Created by Rodolphe Beck on 24/05/2025.
//

import Testing
@testable import Anno_1800_Companion

struct Anno_1800_CompanionTests {

    @Test func example() async throws {
        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
    }
    
    @Test func importPopulationNeeds() async throws {
        let vm = IslandDetailsView.ViewModel(island: .oldWorldExample)
        let population = vm.population
        let need = vm.need
        let producers = vm.producers
        
        for p in population.entries {
            print("Population: \(p.value.name) = \(p.value.id)")
        }
        
//        for p in producers.entries {
//            print("Producer: \(p.key) = \(p.value)")
//        }
        
        vm.calculate()
        
        for n in vm.calculatedNeeds {
            print("Need: \(n.name) \(n.value)")
        }
        
        #expect(need.farmers.basic.count > 0)
        #expect(need.farmers.luxury.count > 0)
        
    }

}
