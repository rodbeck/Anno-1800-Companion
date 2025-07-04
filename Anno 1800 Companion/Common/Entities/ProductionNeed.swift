//
//  ProductionNeed.swift
//  Anno 1800 Companion
//
//  Created by Rodolphe Beck on 04/07/2025.
//

import Foundation

struct ProductionNeed {
    let populationType: String
    let goodName: String
    let producerName: String
    let residences: Int
    let consumptionPerResident: Double
    let totalConsumptionPerMin: Double
    let productionPerMin: Double
    let buildingsNeeded: Int
    let usagePercentage: Double
}
