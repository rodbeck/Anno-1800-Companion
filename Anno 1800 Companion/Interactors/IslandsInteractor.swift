//
//  IslandInteractor.swift
//  Anno 1800 Companion
//
//  Created by Rodolphe Beck on 05/07/2025.
//

import Foundation

protocol IslandsInteractor {
    @MainActor
    func fetchIslandsList() async throws -> [DBModel.Island]
    func store(island: DBModel.Island) async throws
    func delete(island: DBModel.Island) async throws
}

struct RealIslandInteractor: IslandsInteractor {
    let dbRepository: IslandsDBRepository
    
    @MainActor
    func fetchIslandsList() async throws -> [DBModel.Island] {
        try await dbRepository.fetchIslandsList()
    }
    
    func store(island: DBModel.Island) async throws {
        try await dbRepository.store(island: island)
    }
    
    func delete(island: DBModel.Island) async throws {
        try await dbRepository.delete(island: island)
    }
    
    
}

struct StubIslandInteractor: IslandsInteractor {
    func fetchIslandsList() async throws -> [DBModel.Island] {
        return []
    }
    
    func delete(island: DBModel.Island) async throws {
        
    }
    
    func store(island: DBModel.Island) async throws {
        
    }
    
    
}
