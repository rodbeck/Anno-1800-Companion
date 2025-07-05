//
//  IslandInteractor.swift
//  Anno 1800 Companion
//
//  Created by Rodolphe Beck on 05/07/2025.
//

import Foundation

protocol IslandsInteractor {
    func fetchIslandsList() async throws -> [DBModel.Island]
    func store(island: ApiModel.Island) async throws
}

struct RealIslandInteractor: IslandsInteractor {
    let dbRepository: IslandsDBRepository
    
    func fetchIslandsList() async throws -> [DBModel.Island] {
        try await dbRepository.fetchIslandsList()
    }
    
    func store(island: ApiModel.Island) async throws {
        try await dbRepository.store(island: island)
    }
    
    
}

struct StubIslandInteractor: IslandsInteractor {
    func fetchIslandsList() async throws -> [DBModel.Island] {
        return []
    }
    
    func store(island: ApiModel.Island) async throws {
        
    }
    
    
}
