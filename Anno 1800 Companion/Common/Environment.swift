//
//  Environment.swift
//  Anno 1800 Companion
//
//  Created by Rodolphe Beck on 05/07/2025.
//

import Foundation

struct EnvironmentTesting {
    static var isRunningOnSimulator: Bool {
        #if targetEnvironment(simulator)
        return true
        #else
        return false
        #endif
    }
}
