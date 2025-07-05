//
//  AppSchema.swift
//  Anno 1800 Companion
//
//  Created by Rodolphe Beck on 05/07/2025.
//

import Foundation

import SwiftData

enum DBModel { }

extension Schema {
    private static var actualVersion: Schema.Version = Version(1, 0, 0)

    static var appSchema: Schema {
        Schema([
            DBModel.Island.self
        ], version: actualVersion)
    }
}
