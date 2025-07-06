//
//  IslandDetailsViewModel.swift
//  Anno 1800 Companion
//
//  Created by Rodolphe Beck on 06/07/2025.
//

import Foundation

extension IslandDetailsView {
    @Observable
    class ViewModel {
        var regions: Regions
        var isCalculateEnabled: Bool = false
        var isSaveEnabled: Bool = false
        
        init() {
            self.regions = Bundle.main.decode(Regions.self, from: "regions.json")
        }
    }
}
