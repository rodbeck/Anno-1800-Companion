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
        
        init(island: Island) {
            self.island = island
        }
    }
    
    static var oldWorldExample: ViewModel {
        ViewModel(island: .oldWorldExample)
    }
    
    static var newWorldExample: ViewModel {
        ViewModel(island: .newWorldExample)
    }
}


