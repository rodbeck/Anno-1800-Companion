//
//  DIContainer.swift
//  Anno 1800 Companion
//
//  Created by Rodolphe Beck on 05/07/2025.
//

import SwiftUI
import Foundation

struct DIContainer {
    
    let appState: Store<AppState>
    let interactors: Interactors
    
    init(appState: Store<AppState> = .init(AppState()), interactors: Interactors) {
        self.appState = appState
        self.interactors = interactors
    }
    
    init(appState: AppState, interactors: Interactors) {
        self.init(appState: Store<AppState>(appState), interactors: interactors)
    }
}

extension DIContainer {
    
    struct DBRepositories {
        let islands: IslandsDBRepository
    }
    
    struct Interactors {
        let islands: IslandsInteractor
        
        static var stub: Self {
            .init(islands: StubIslandInteractor())
        }
    }
}

extension EnvironmentValues {
    @Entry var injected: DIContainer = DIContainer(interactors: .stub)
}

extension View {
    func inject(_ container: DIContainer) -> some View {
        return self
            .environment(\.injected, container)
    }
}
