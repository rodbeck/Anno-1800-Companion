//
//  Population.swift
//  Anno 1800 Companion
//
//  Created by Rodolphe Beck on 28/05/2025.
//

import Foundation

protocol Population {
    var id: Int { get set }
    var name: String { get set }
    var image: String { get set }
    var firstProductionChain: Int { get set }
    var residence: Int { get set }
    var basicNeeds: [BasicNeed] { get set }
    var luxuryNeeds: [LuxuryNeed] { get set }
}
