//
//  IslandsDBRepository.swift
//  Anno 1800 Companion
//
//  Created by Rodolphe Beck on 05/07/2025.
//

import SwiftData
import Foundation

protocol IslandsDBRepository {
    @MainActor
    func fetchIslandsList() async throws -> [DBModel.Island]
    func store(island: ApiModel.Island) async throws
    @MainActor
    func delete(island: DBModel.Island) async throws
}

extension MainDBRepository: IslandsDBRepository {
    
    @MainActor
    func fetchIslandsList() async throws -> [DBModel.Island] {
        let islandFetchDescriptor = FetchDescriptor<DBModel.Island>()
        let islands = try modelContainer.mainContext.fetch(islandFetchDescriptor)
        
        print("Fetching islands: \(islands.count)")
        
        return islands
    }
    
    @MainActor
    func delete(island: DBModel.Island) async throws {
        modelContainer.mainContext.delete(island)
        try modelContainer.mainContext.save()
    }
    
    func store(island: ApiModel.Island) async throws {
        print("Inserting island \(island.name)")
        modelContext.insert(island.dbModel())
        try modelContext.save()
    }
}

internal extension ApiModel.Island {
    func dbModel() -> DBModel.Island {
        return .init(name: self.name, region: .init(rawValue: self.region), farmers: self.farmers, workers: self.workers, artisans: self.artisans, engineers: self.engineers, investors: self.investors, jornaleros: self.jornaleros, obreros: self.obreros, explorers: self.explorers, technicians: self.technicians, sheperds: self.sheperds, elders: self.elders)
    }
}
