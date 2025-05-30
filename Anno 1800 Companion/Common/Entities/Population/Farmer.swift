//
//  Farmer.swift
//  Anno 1800 Companion
//
//  Created by Rodolphe Beck on 28/05/2025.
//

import Foundation

struct Farmer: Population {
    var id: Int = 1
    
    var name: String = "Farmers"
    
    var image: String = "population/farmers"
    
    var firstProductionChain: Int = 1
    
    var residence: Int = 10

    var basicNeeds: [any BasicNeed] = [Fish(value: 0.025000002)]
    
    var luxuryNeeds: [any LuxuryNeed] = [Shnaps(value: 0.03333336)]
}
