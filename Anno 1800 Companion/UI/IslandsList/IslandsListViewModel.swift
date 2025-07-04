//
//  IslandsListViewModel.swift
//  Anno 1800 Companion
//
//  Created by Rodolphe Beck on 30/05/2025.
//

import Foundation

extension IslandsListView {
    @Observable
    class ViewModel {
        
        var showingSheet: Bool = false
        var selectedIslandId: Int?
        
        var islands: [Island] = [.newWorldExample, .oldWorldExample, .enbesaExample, .theArcticExample]
        
        static var example: ViewModel {
            let vm = ViewModel()
            vm.islands = [.newWorldExample, .oldWorldExample, .enbesaExample, .theArcticExample]
            
            return vm
        }
    }
}
