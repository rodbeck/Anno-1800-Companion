//
//  AppState.swift
//  Anno 1800 Companion
//
//  Created by Rodolphe Beck on 05/07/2025.
//

import Foundation

struct AppState: Equatable {
    var system = System()
    
    struct System: Equatable {
        var isActive: Bool = false
        var keyboardHeight: CGFloat = 0
    }
}
