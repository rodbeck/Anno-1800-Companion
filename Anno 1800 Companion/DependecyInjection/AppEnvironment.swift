//
//  AppEnvironment.swift
//  Anno 1800 Companion
//
//  Created by Rodolphe Beck on 05/07/2025.
//

import SwiftData
import Foundation

@MainActor
struct AppEnvironment {
    let isRunningTests: Bool
    let diContainer: DIContainer
    let modelContainer: ModelContainer
}


extension AppEnvironment {
    
    static func bootstrap() -> AppEnvironment {
        
        let modelContainer = configuredModelContainer()
        let dbRepositories = configuredDBRepositories(modelContainer: modelContainer)
        let interactors = configuredInteractors(dbRepositories: dbRepositories)
        let diContainter = DIContainer(interactors: interactors)
        
        return AppEnvironment(
            isRunningTests: ProcessInfo.processInfo.isRunningTests,
            diContainer: diContainter,
            modelContainer: modelContainer
        )
    }
    
    private static func configuredDBRepositories(modelContainer: ModelContainer) -> DIContainer.DBRepositories {
        let mainDBRepository = MainDBRepository(modelContainer: modelContainer)
        return .init(islands: mainDBRepository)
    }
    
    private static func configuredModelContainer() -> ModelContainer {
        do {
            return try ModelContainer.appModelContainer()
        } catch {
            // Log the error
            return ModelContainer.stub
        }
    }
    
    private static func configuredInteractors(dbRepositories: DIContainer.DBRepositories) -> DIContainer.Interactors {
        let islands = RealIslandInteractor(dbRepository: dbRepositories.islands)
        
        return .init(islands: islands)
    }
}
